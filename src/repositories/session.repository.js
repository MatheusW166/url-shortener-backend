import db from "../database/database.connection.js";

async function searchByToken({ token }) {
  const { rows } = await db.query(
    `SELECT *, user_id AS "userId" FROM sessions WHERE token=$1;`,
    [token]
  );
  if (rows[0]) delete rows[0].user_id;
  return rows[0];
}

async function create({ userId, token }) {
  const { rows } = await db.query(
    "INSERT INTO sessions(user_id,token) VALUES($1,$2) RETURNING *, user_id AS userId;",
    [userId, token]
  );
  delete rows[0].user_id;
  return rows[0];
}

export const sessionRepository = { searchByToken, create };
