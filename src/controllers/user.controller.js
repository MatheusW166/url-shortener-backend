import { v4 as uuidV4 } from "uuid";
import { userRepository } from "../repositories/user.repository.js";
import { sessionRepository } from "../repositories/session.repository.js";
import { compareSync, hashSync } from "bcrypt";

async function signUp(req, res) {
  try {
    const hashedPassword = hashSync(req.body.password, 10);
    const user = await userRepository.create({
      ...req.body,
      password: hashedPassword,
    });
    res.status(201).send(user);
  } catch (err) {
    if (err?.message?.includes("duplicate")) {
      return res.status(409).send({ error: "this email already exists" });
    }
    res.sendStatus(500);
  }
}

async function logIn(req, res) {
  const { email, password } = req.body;
  try {
    const userFound = await userRepository.searchByEmail({ email });
    if (!userFound) {
      return res.status(401).send({ error: "user not found" });
    }
    if (!compareSync(password, userFound.password)) {
      return res.status(401).send({ error: "wrong password" });
    }
    const token = uuidV4();
    await sessionRepository.create({ userId: userFound.id, token });
    delete userFound.password;
    res.send({ ...userFound, token });
  } catch (err) {
    res.sendStatus(500);
  }
}

async function getMe(req, res) {
  const { userId } = req.session;
  try {
    const userMeResult = await userRepository.getMe({ id: userId });
    if (!userMeResult) {
      return res.sendStatus(404);
    }
    res.send(userMeResult);
  } catch (err) {
    console.log(err);
    res.sendStatus(500);
  }
}

export const userController = { signUp, logIn, getMe };
