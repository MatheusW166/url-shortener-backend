import { Router } from "express";
import validateSchema from "../middlewares/schema.middleware.js";
import { urlController } from "../controllers/url.controller.js";
import urlSchema from "../schemas/url.schema.js";
import validateToken from "../middlewares/auth.middleware.js";

const urlRoutes = Router();

urlRoutes.post(
  "/urls/shorten",
  validateSchema(urlSchema),
  validateToken,
  urlController.shorten
);
urlRoutes.get("/urls/:id", urlController.getById);
urlRoutes.get("/urls/open/:shortUrl", urlController.openUrl);
urlRoutes.get("/ranking", urlController.getRank);
urlRoutes.delete("/urls/:id", validateToken, urlController.deleteById);

export default urlRoutes;
