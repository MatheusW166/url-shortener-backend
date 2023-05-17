import { Router } from "express";
import userRoutes from "./user.routes.js";
import urlRoutes from "./url.routes.js";

const indexRoutes = Router();

indexRoutes.use(userRoutes);
indexRoutes.use(urlRoutes);

export default indexRoutes;
