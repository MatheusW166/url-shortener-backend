import { nanoid } from "nanoid";
import { urlRepository } from "../repositories/url.repository.js";

async function shorten(req, res) {
  const { url } = req.body;
  const { userId } = req.session;
  try {
    const shorten = await urlRepository.create({
      url,
      userId,
      shortUrl: nanoid(),
    });
    res.status(201).send(shorten);
  } catch (err) {
    res.sendStatus(500);
  }
}

async function getById(req, res) {
  const { id } = req.params;
  try {
    const urlFound = await urlRepository.searchById({ id });
    if (!urlFound) return res.sendStatus(404);
    delete urlFound.userId;
    res.send(urlFound);
  } catch (err) {
    res.sendStatus(500);
  }
}

async function openUrl(req, res) {
  const { shortUrl } = req.params;
  try {
    const urlFound = await urlRepository.searchByShortUrl({ shortUrl });
    if (!urlFound) return res.sendStatus(404);
    await urlRepository.incrementUrlVisits({ shortUrl });
    res.redirect(urlFound.url);
  } catch (err) {
    res.sendStatus(500);
  }
}

async function deleteById(req, res) {
  const { id } = req.params;
  const { userId } = req.session;
  try {
    const urlFound = await urlRepository.searchById({ id });
    if (!urlFound) return res.sendStatus(404);
    if (urlFound.userId !== Number(userId)) return res.sendStatus(401);
    await urlRepository.deleteById({ id });
    res.sendStatus(204);
  } catch (err) {
    res.sendStatus(500);
  }
}

async function getRank(_, res) {
  try {
    const rank = await urlRepository.getRank();
    res.send(rank);
  } catch (err) {
    res.sendStatus(500);
  }
}

export const urlController = { shorten, getById, openUrl, deleteById, getRank };
