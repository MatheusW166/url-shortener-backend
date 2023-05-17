import { Router } from "express";
import { userController } from "../controllers/user.controller.js";
import validateSchema from "../middlewares/schema.middleware.js";
import { createUserSchema, loginUserSchema } from "../schemas/user.schema.js";
import validateToken from "../middlewares/auth.middleware.js";

const userRoutes = Router();

userRoutes.post(
  "/signup",
  validateSchema(createUserSchema),
  userController.signUp
);
userRoutes.post(
  "/signin",
  validateSchema(loginUserSchema),
  userController.logIn
);
userRoutes.get("/users/me", validateToken, userController.getMe);

export default userRoutes;
