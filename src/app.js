import express from "express";
import cors from "cors";
import { config } from "dotenv";
import indexRoutes from "./routes/index.routes.js";
config();

const app = express();

app.use(express.json());
app.use(cors());
app.use(indexRoutes);

const PORT = process.env.PORT;
app.listen(PORT, () => console.log(`🚀 Running on PORT ${PORT}`));
