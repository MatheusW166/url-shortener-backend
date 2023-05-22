import db from "../database/database.connection.js";

async function create({ name, email, password }) {
  const { rows } = await db.query(
    "INSERT INTO users(name,email,password) VALUES($1,$2,$3) RETURNING *;",
    [name, email, password]
  );
  delete rows[0].created_at;
  delete rows[0].password;
  return rows[0];
}

async function searchByEmail({ email }) {
  const { rows } = await db.query(
    `SELECT *, created_at AS "createdAt" FROM users WHERE email=$1;`,
    [email]
  );
  if (rows[0]) delete rows[0].created_at;
  return rows[0];
}

async function searchById({ id }) {
  const { rows } = await db.query("SELECT * FROM users WHERE id=$1;", [id]);
  return rows[0];
}

async function getMe({ id }) {
  const userVisitCount = await db.query(
    `
    SELECT users.id, users.name, SUM(visit_count) AS "visitCount" FROM users 
    LEFT JOIN urls ON users.id=urls.user_id WHERE users.id=$1 GROUP BY users.id, users.name;
  `,
    [id]
  );

  if (!userVisitCount.rows[0]) return null;

  const shortenedUrls = await db.query(
    `SELECT id, short_url AS "shortUrl", url, visit_count AS "visitCount" 
    FROM urls WHERE user_id=$1 ORDER BY created_at DESC;`,
    [id]
  );

  const userData = {
    ...userVisitCount.rows[0],
    shortenedUrls: shortenedUrls.rows,
  };

  console.log(userData);

  return userData;
}

export const userRepository = { create, searchByEmail, searchById, getMe };
