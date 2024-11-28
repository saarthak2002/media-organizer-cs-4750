const sql = require('mssql')
const express = require('express');
const cookieParser = require("cookie-parser");

const DATABASE_CONNECTION_STRING = "Server=localhost,1433;Database=MediaOrganizerApp;User Id=sa;Password=CS4750@2024!;Encrypt=true;TrustServerCertificate=true"

const queryDatabase = async (query) => {
    try {
        await sql.connect(DATABASE_CONNECTION_STRING);
        console.log('DB connected.')
        const result = await sql.query(query);
        return result;
    }
    catch(error) {
        console.log("Error conencting to database: ", error);
    }
}

const app = express();
let port=3001;

app.use(express.json());
app.use(cookieParser());
app.listen(port, () => {console.log(`listening on port ${port}`)});

app.get('/', async (request, response) => {
    const results = await queryDatabase(`SELECT TOP 1 * FROM Media;`)
    response.send({'dbTest': results});
    console.log(results)
})

///////////////////////////// MOVIES ////////////////////////////////////////

// GET
app.get('/movies/:id', async (request, response) => {
    const movieId = request.params.id;
    try {
        const result = await queryDatabase(`
            SELECT m.*, mv.*
            FROM Media m
            JOIN Movies mv ON m.mediaId = mv.mediaId
            WHERE m.mediaId = ${movieId};
        `);
        if (result.recordset.length === 0) {
            return response.status(404).send({ message: "Movie not found" });
        }
        response.send(result.recordset[0]);
    } catch (error) {
        response.status(500).send({ error: "Error retrieving movie" });
    }
});

// POST
app.post('/movies', async (request, response) => {
    const { mediaId, name, overview, poster_path, release_date, genre, type, language, rating, leadActor, leadActorCharacter, supportingActor, supportingActorCharacter, director } = request.body;
    if (!mediaId || !name || !overview || !poster_path || !release_date || !genre || !type || !language || rating == null || !leadActor || !leadActorCharacter || !supportingActor || !supportingActorCharacter || !director) {
        return response.status(400).send({ message: "Invalid request. Missing required fields." });
    }
    if (type !== 'MOVIE') return response.status(400).send({ message: "Invalid type, must be 'MOVIE'" });

    const pool = await sql.connect(DATABASE_CONNECTION_STRING);
    const transaction = new sql.Transaction(pool);

    try {
        await transaction.begin();
        await transaction.request()
            .query(`
                INSERT INTO Media (mediaId, name, overview, poster_path, release_date, genre, type)
                VALUES (${mediaId}, '${name}', '${overview}', '${poster_path}', '${release_date}', '${genre}', '${type}');
            `);
        await transaction.request()
            .query(`
                INSERT INTO Movies (mediaId, language, rating, leadActor, leadActorCharacter, supportingActor, supportingActorCharacter, director)
                VALUES (${mediaId}, '${language}', ${rating}, '${leadActor}', '${leadActorCharacter}', '${supportingActor}', '${supportingActorCharacter}', '${director}');
            `);
        await transaction.commit();
        response.status(201).send({ message: "Movie added successfully" });
    } catch (error) {
        await transaction.rollback();
        response.status(500).send({ error: "Error adding movie", details: error.message });
    }
});

// PUT
app.put('/movies/:id', async (request, response) => {
    const movieId = request.params.id;
    const { name, overview, poster_path, release_date, genre, language, rating, leadActor, leadActorCharacter, supportingActor, supportingActorCharacter, director } = request.body;

    const pool = await sql.connect(DATABASE_CONNECTION_STRING);
    const transaction = new sql.Transaction(pool);

    try {
        await transaction.begin();

        // Update Media Table
        const mediaFields = [];
        if (name) mediaFields.push(`name = '${name}'`);
        if (overview) mediaFields.push(`overview = '${overview}'`);
        if (poster_path) mediaFields.push(`poster_path = '${poster_path}'`);
        if (release_date) mediaFields.push(`release_date = '${release_date}'`);
        if (genre) mediaFields.push(`genre = '${genre}'`);

        if (mediaFields.length > 0) {
            const mediaQuery = `
                UPDATE Media
                SET ${mediaFields.join(', ')}
                WHERE mediaId = ${movieId};
            `;
            await transaction.request().query(mediaQuery);
        }

        // Update Movies Table
        const moviesFields = [];
        if (language) moviesFields.push(`language = '${language}'`);
        if (rating != null) moviesFields.push(`rating = ${rating}`);
        if (leadActor) moviesFields.push(`leadActor = '${leadActor}'`);
        if (leadActorCharacter) moviesFields.push(`leadActorCharacter = '${leadActorCharacter}'`);
        if (supportingActor) moviesFields.push(`supportingActor = '${supportingActor}'`);
        if (supportingActorCharacter) moviesFields.push(`supportingActorCharacter = '${supportingActorCharacter}'`);
        if (director) moviesFields.push(`director = '${director}'`);

        if (moviesFields.length > 0) {
            const moviesQuery = `
                UPDATE Movies
                SET ${moviesFields.join(', ')}
                WHERE mediaId = ${movieId};
            `;
            await transaction.request().query(moviesQuery);
        }

        await transaction.commit();
        response.send({ message: "Movie updated successfully" });
    } catch (error) {
        await transaction.rollback();
        response.status(500).send({ error: "Error updating movie", details: error.message });
    }
});

// DELETE
app.delete('/movies/:id', async (request, response) => {
    const movieId = request.params.id;
    const pool = await sql.connect(DATABASE_CONNECTION_STRING);
    const transaction = new sql.Transaction(pool);

    try {
        await transaction.begin();
        await transaction.request()
            .query(`DELETE FROM Movies WHERE mediaId = ${movieId};`);
        await transaction.request()
            .query(`DELETE FROM Media WHERE mediaId = ${movieId};`);
        await transaction.commit();
        response.send({ message: "Movie deleted successfully" });
    } catch (error) {
        await transaction.rollback();
        response.status(500).send({ error: "Error deleting movie", details: error.message });
    }
});

//////////////////////////////////////////////////////////////////////////////

///////////////////////////// GAMES //////////////////////////////////////////

// GET
app.get('/games/:id', async (request, response) => {
    const gameId = request.params.id;
    try {
        const result = await queryDatabase(`
            SELECT m.*, g.*
            FROM Media m
            JOIN Games g ON m.mediaId = g.mediaId
            WHERE m.mediaId = ${gameId};
        `);
        if (result.recordset.length === 0) {
            return response.status(404).send({ message: "Game not found" });
        }
        response.send(result.recordset[0]);
    } catch (error) {
        response.status(500).send({ error: "Error retrieving game", details: error.message  });
    }
});

// POST
app.post('/games', async (request, response) => {
    const { mediaId, name, overview, poster_path, release_date, genre, type, publisher, platform, metacritic, esrbRating } = request.body;
    if (!mediaId || !name || !overview || !poster_path || !release_date || !genre || !type || !publisher || !platform || metacritic == null || !esrbRating) {
        return response.status(400).send({ message: "Invalid request. Missing required fields." });
    }
    if (type !== 'GAME') return response.status(400).send({ message: "Invalid type, must be 'GAME'" });

    const pool = await sql.connect(DATABASE_CONNECTION_STRING);
    const transaction = new sql.Transaction(pool);
    try {
        await transaction.begin();
        await transaction.request()
            .query(`
                INSERT INTO Media (mediaId, name, overview, poster_path, release_date, genre, type)
                VALUES (${mediaId}, '${name}', '${overview}', '${poster_path}', '${release_date}', '${genre}', '${type}');
            `);
        await transaction.request()
            .query(`
                INSERT INTO Games (mediaId, publisher, platform, metacritic, esrbRating)
                VALUES (${mediaId}, '${publisher}', '${platform}', ${metacritic}, '${esrbRating}');
            `);
        await transaction.commit();
        response.status(201).send({ message: "Game added successfully" });
    } catch (error) {
        await transaction.rollback();
        response.status(500).send({ error: "Error adding game", details: error.message });
    }
});

// PUT
app.put('/games/:id', async (request, response) => {
    const gameId = request.params.id;
    const { name, overview, poster_path, release_date, genre, publisher, platform, metacritic, esrbRating } = request.body;

    const pool = await sql.connect(DATABASE_CONNECTION_STRING);
    const transaction = new sql.Transaction(pool);

    try {
        await transaction.begin();

        // Update Media Table
        const mediaFields = [];
        if (name) mediaFields.push(`name = '${name}'`);
        if (overview) mediaFields.push(`overview = '${overview}'`);
        if (poster_path) mediaFields.push(`poster_path = '${poster_path}'`);
        if (release_date) mediaFields.push(`release_date = '${release_date}'`);
        if (genre) mediaFields.push(`genre = '${genre}'`);

        if (mediaFields.length > 0) {
            const mediaQuery = `
                UPDATE Media
                SET ${mediaFields.join(', ')}
                WHERE mediaId = ${gameId};
            `;
            await transaction.request().query(mediaQuery);
        }

        // Update Games Table
        const gamesFields = [];
        if (publisher) gamesFields.push(`publisher = '${publisher}'`);
        if (platform) gamesFields.push(`platform = '${platform}'`);
        if (metacritic != null) gamesFields.push(`metacritic = ${metacritic}`);
        if (esrbRating) gamesFields.push(`esrbRating = '${esrbRating}'`);

        if (gamesFields.length > 0) {
            const gamesQuery = `
                UPDATE Games
                SET ${gamesFields.join(', ')}
                WHERE mediaId = ${gameId};
            `;
            await transaction.request().query(gamesQuery);
        }

        await transaction.commit();
        response.send({ message: "Game updated successfully" });
    } catch (error) {
        await transaction.rollback();
        response.status(500).send({ error: "Error updating game", details: error.message });
    }
});

// DELETE
app.delete('/games/:id', async (request, response) => {
    const gameId = request.params.id;
    const pool = await sql.connect(DATABASE_CONNECTION_STRING);
    const transaction = new sql.Transaction(pool);
    try {
        await transaction.begin();

        await transaction.request()
            .query(`DELETE FROM Games WHERE mediaId = ${gameId};`);

        await transaction.request()
            .query(`DELETE FROM Media WHERE mediaId = ${gameId};`);

        await transaction.commit();
        response.send({ message: "Game deleted successfully" });
    } catch (error) {
        await transaction.rollback();
        response.status(500).send({ error: "Error deleting game", details: error.message  });
    }
});

//////////////////////////////////////////////////////////////////////////////

///////////////////////////// TV SHOWS //////////////////////////////////////////

// GET
app.get('/tv/:id', async (request, response) => {
    const tvId = request.params.id;
    try {
        const result = await queryDatabase(`
            SELECT m.*, tv.*
            FROM Media m
            JOIN Tv tv ON m.mediaId = tv.mediaId
            WHERE m.mediaId = ${tvId};
        `);
        if (result.recordset.length === 0) {
            return response.status(404).send({ message: "TV show not found" });
        }
        response.send(result.recordset[0]);
    } catch (error) {
        response.status(500).send({ error: "Error retrieving TV show", details: error.message });
    }
});

// POST
app.post('/tv', async (request, response) => {
    const { mediaId, name, overview, poster_path, release_date, genre, type, language, rating, numberOfEpisodes, numberOfSeasons, status, network } = request.body;

    if (!mediaId || !name || !overview || !poster_path || !release_date || !genre || !type || !language || rating == null || !numberOfEpisodes || !numberOfSeasons || !status || !network) {
        return response.status(400).send({ message: "Invalid request. Missing required fields." });
    }
    if (type !== 'TV') return response.status(400).send({ message: "Invalid type, must be 'TV'" });

    const pool = await sql.connect(DATABASE_CONNECTION_STRING);
    const transaction = new sql.Transaction(pool);

    try {
        await transaction.begin();

        await transaction.request()
            .query(`
                INSERT INTO Media (mediaId, name, overview, poster_path, release_date, genre, type)
                VALUES (${mediaId}, '${name}', '${overview}', '${poster_path}', '${release_date}', '${genre}', '${type}');
            `);

        await transaction.request()
            .query(`
                INSERT INTO Tv (mediaId, language, rating, numberOfEpisodes, numberOfSeasons, status, network)
                VALUES (${mediaId}, '${language}', ${rating}, ${numberOfEpisodes}, ${numberOfSeasons}, '${status}', '${network}');
            `);

        await transaction.commit();
        response.status(201).send({ message: "TV show added successfully" });
    } catch (error) {
        await transaction.rollback();
        response.status(500).send({ error: "Error adding TV show", details: error.message });
    }
});

// PUT
app.put('/tv/:id', async (request, response) => {
    const tvId = request.params.id;
    const { name, overview, poster_path, release_date, genre, language, rating, numberOfEpisodes, numberOfSeasons, status, network } = request.body;

    const pool = await sql.connect(DATABASE_CONNECTION_STRING);
    const transaction = new sql.Transaction(pool);

    try {
        await transaction.begin();

        // Update Media Table
        const mediaFields = [];
        if (name) mediaFields.push(`name = '${name}'`);
        if (overview) mediaFields.push(`overview = '${overview}'`);
        if (poster_path) mediaFields.push(`poster_path = '${poster_path}'`);
        if (release_date) mediaFields.push(`release_date = '${release_date}'`);
        if (genre) mediaFields.push(`genre = '${genre}'`);

        if (mediaFields.length > 0) {
            const mediaQuery = `
                UPDATE Media
                SET ${mediaFields.join(', ')}
                WHERE mediaId = ${tvId};
            `;
            await transaction.request().query(mediaQuery);
        }

        // Update TV Table
        const tvFields = [];
        if (language) tvFields.push(`language = '${language}'`);
        if (rating != null) tvFields.push(`rating = ${rating}`);
        if (numberOfEpisodes) tvFields.push(`numberOfEpisodes = ${numberOfEpisodes}`);
        if (numberOfSeasons) tvFields.push(`numberOfSeasons = ${numberOfSeasons}`);
        if (status) tvFields.push(`status = '${status}'`);
        if (network) tvFields.push(`network = '${network}'`);

        if (tvFields.length > 0) {
            const tvQuery = `
                UPDATE Tv
                SET ${tvFields.join(', ')}
                WHERE mediaId = ${tvId};
            `;
            await transaction.request().query(tvQuery);
        }

        await transaction.commit();
        response.send({ message: "TV show updated successfully" });
    } catch (error) {
        await transaction.rollback();
        response.status(500).send({ error: "Error updating TV show", details: error.message });
    }
});

// DELETE
app.delete('/tv/:id', async (request, response) => {
    const tvId = request.params.id;
    const pool = await sql.connect(DATABASE_CONNECTION_STRING);
    const transaction = new sql.Transaction(pool);

    try {
        await transaction.begin();

        await transaction.request()
            .query(`DELETE FROM Tv WHERE mediaId = ${tvId};`);

        await transaction.request()
            .query(`DELETE FROM Media WHERE mediaId = ${tvId};`);

        await transaction.commit();
        response.send({ message: "TV show deleted successfully" });
    } catch (error) {
        await transaction.rollback();
        response.status(500).send({ error: "Error deleting TV show", details: error.message });
    }
});

//////////////////////////////////////////////////////////////////////////////
