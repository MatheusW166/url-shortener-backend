import { validate } from "uuid";
import { sessionRepository } from "../repositories/session.repository.js";

async function validateToken(req, res, next) {
  const { authorization } = req.headers;
  const token = authorization?.replace("Bearer ", "");

  if (!token) return res.status(401).send({ error: "token does not exist" });
  if (!validate(token)) return res.status(401).send({ error: "token invalid" });

  try {
    const session = await sessionRepository.searchByToken({ token });
    if (!session) return res.status(401).send({ error: "token not found" });
    req.session = session;

    next();
  } catch (err) {
    res.status(500).send(err.message);
  }
}

export default validateToken;
