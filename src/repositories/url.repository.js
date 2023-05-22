import db from "../database/database.connection.js";

async function create({ url, shortUrl, userId }) {
  const { rows } = await db.query(
    `INSERT INTO urls(url,short_url,user_id) VALUES($1,$2,$3) RETURNING id, short_url AS "shortUrl";`,
    [url, shortUrl, userId]
  );
  return rows[0];
}

async function deleteById({ id }) {
  const { rowCount } = await db.query("DELETE FROM urls WHERE id=$1;", [id]);
  return { deletedCount: rowCount };
}

async function searchByShortUrl({ shortUrl }) {
  const { rows } = await db.query("SELECT * FROM urls WHERE short_url=$1;", [
    shortUrl,
  ]);
  return rows[0];
}

async function searchById({ id }) {
  const { rows } = await db.query(
    `SELECT id, short_url AS "shortUrl",user_id AS "userId", url FROM urls WHERE id=$1;`,
    [id]
  );
  return rows[0];
}

async function searchByUser({ userId }) {
  const { rows } = await db.query(
    `SELECT id, short_url AS "shortUrl", user_id AS "userId" , url FROM urls WHERE user_id=$1;`,
    [userId]
  );
  return rows;
}

async function getRank() {
  const { rows } = await db.query(`
  SELECT 
    users.id,
    users.name,
    COUNT(*) AS "linksCount", 
    SUM(visit_count) AS "visitCount"
  FROM urls JOIN users ON urls.user_id=users.id 
  GROUP BY users.id, users.name ORDER BY SUM(visit_count) DESC LIMIT 10;`);
  return rows;
}

async function incrementUrlVisits({ shortUrl }) {
  return await db.query(`CALL increment_visit($1);`, [shortUrl]);
}

export const urlRepository = {
  create,
  searchByShortUrl,
  searchById,
  searchByUser,
  deleteById,
  getRank,
  incrementUrlVisits,
};
