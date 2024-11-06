USE MediaOrganizerApp;
GO

-- 5. Implement 1 Column Encryption :- For any 1 column in your table, implement the column
-- encryption for security purposes
-- Note: Modify passwordHash to VARBINARY(256) in [user] table
-- We will encrypt the password column in the user table so passwords are not visible as plaintext
-- Create Certificate and Symmetric Key
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Media_Organizer_App@2024!';

CREATE CERTIFICATE UserCert 
WITH SUBJECT = 'Certificate for user password encryption';

CREATE SYMMETRIC KEY UserKey 
WITH ALGORITHM = AES_256 
ENCRYPTION BY CERTIFICATE UserCert;

-- Insert user with encrypted password
OPEN SYMMETRIC KEY UserKey 
DECRYPTION BY CERTIFICATE UserCert;

INSERT INTO [user] (email, passwordHash, firstName, lastName)
VALUES (
    'john.doe@gmail.com', EncryptByKey(Key_GUID('UserKey'), 'password123'),
    'John', 'Doe'
);

CLOSE SYMMETRIC KEY UserKey;

-- View user with decrypted password
OPEN SYMMETRIC KEY UserKey 
DECRYPTION BY CERTIFICATE UserCert;

SELECT
    email, 
    CONVERT(VARCHAR(256), DecryptByKey(passwordHash)) AS [password],
    firstName,
    lastName
FROM [user];

CLOSE SYMMETRIC KEY UserKey;
GO

-- 1. Create 3 Stored Procedures :- For your project create three stored procedures and emphasize
-- how or why they would be used

-- This procedure will be used to insert a new User into the database- including handling encryption for the password.
-- This will make insert (POST) user operations simpler.

CREATE PROCEDURE AddNewUser
        @email NVARCHAR(255),
        @plaintext_password NVARCHAR(255),
        @firstName NVARCHAR(255),
        @lastName NVARCHAR(255)
    AS
    BEGIN
        OPEN SYMMETRIC KEY UserKey 
        DECRYPTION BY CERTIFICATE UserCert;

        INSERT INTO [user] (email, passwordHash, firstName, lastName)
        VALUES (
            @email, EncryptByKey(Key_GUID('UserKey'), @plaintext_password),
            @firstName, @lastName
        );

        CLOSE SYMMETRIC KEY UserKey;

    END;
GO

EXEC AddNewUser
    @email = 'jane.doe@email.com',
    @plaintext_password = 'password789',
    @firstName = 'Jane',
    @lastName = 'Doe';
GO

-- This procedure will be used to retrieve an existing User from the database by their email
-- and then verify if the passwords match- handling password decryption as well.
-- This will make user authentication easier using an API.

CREATE PROCEDURE AuthenticateUser
        @email NVARCHAR(255),
        @password NVARCHAR(255),
        @UserAuthenticated BIT OUTPUT
    AS
    BEGIN
        
        DECLARE @PasswordOnFile NVARCHAR(255);
        SET @UserAuthenticated = 0;

        OPEN SYMMETRIC KEY UserKey 
        DECRYPTION BY CERTIFICATE UserCert;

        SELECT @PasswordOnFile = CONVERT(VARCHAR(256), DecryptByKey(passwordHash))
        FROM [user]
        WHERE email = @email;

        CLOSE SYMMETRIC KEY UserKey;

        IF @PasswordOnFile IS NOT NULL AND @PasswordOnFile = @password
        BEGIN
            SET @UserAuthenticated = 1;
        END
    END;
GO

DECLARE @IsAuthenticated BIT;

EXEC AuthenticateUser
    @email = 'jane.doe@email.com',
    @password = 'password789',
    @UserAuthenticated = @IsAuthenticated OUTPUT


SELECT CASE WHEN @IsAuthenticated = 1 
        THEN 'User authenticated' 
        ELSE 'Authentication failed' 
    END AS AuthenticationStatus;
GO

-- This procedure will be used to create a new collection for a user.
-- Since creating new collections is likely to be a frequently repeated operation in our app,
-- having it as a store procedure will make our implementation easier

CREATE PROCEDURE AddNewCollection
        @collectionName NVARCHAR(255),
        @collectionDesc TEXT,
        @userId INT
    AS
    BEGIN
        BEGIN TRANSACTION;

        INSERT INTO [Collection] (collectionName, collectionDesc)
        VALUES (@collectionName, @collectionDesc);

        -- Get last identity value inserted in current scope
        DECLARE @newCollectionId INT;
        SET @newCollectionId = SCOPE_IDENTITY();

        INSERT INTO [User_Creates_Collection] (collectionId, userId)
        VALUES (@newCollectionId, @userId);

        COMMIT TRANSACTION;
    END;
GO

EXEC AddNewCollection
    @collectionName = 'Janes New Collection',
    @collectionDesc = 'A new test collection created by Jane Doe',
    @userId = 2;
GO

-- 2. Create 3 functions :- For your project create three functions and emphasize how or why they
-- would be used

-- This function will be used to fetch the full name of a user given their user id
-- It will be useful for displaying the user's name on the dashboard once they logon

CREATE FUNCTION dbo.getFullName (
        @UserId INT
    )
    RETURNS NVARCHAR(510)
    AS
    BEGIN
        DECLARE @FullName NVARCHAR(510);

        SELECT @FullName = firstName + ' ' + lastName
        FROM [user]
        WHERE id = @UserId;

        RETURN @FullName;
    END;
GO

SELECT dbo.getFullName(1) AS FullName;
GO

-- This function will be used to find the average ratings of media that have gotten user reviews.
-- It was be used to display an aggregate rating for a media item on the details page of the website.

CREATE FUNCTION dbo.averageRating (
        @mediaName NVARCHAR(255)
    )
    RETURNS DECIMAL(6, 2)
    AS
    BEGIN
        DECLARE @AvgRating DECIMAL(6, 2);

        SELECT @AvgRating = AVG(CAST(r.rating AS DECIMAL(6, 2)))
        FROM Media m
        JOIN Review_for rf ON m.mediaId = rf.mediaId
        JOIN Review r ON rf.reviewId = r.reviewId
        GROUP BY m.mediaId, m.[name]
        HAVING m.[name] = @mediaName;

        RETURN @AvgRating;

    END;
GO

SELECT dbo.averageRating('Dunkirk') AS AvgRating;
GO

-- This table-valued function will be used to find the most common genres of the media added to a specific collection
-- (identified) by a collection id. This will help us determine the over themes of a particular collection
-- in our app. We plan to use this to display the most common genres for a collection created by a user.

CREATE FUNCTION dbo.getCollectionGenreCounts (
        @collectionId INT
    )
    RETURNS TABLE
    AS
    RETURN
    (
        SELECT m.genre, COUNT(*) AS genre_count
        FROM [Collection_Contains_Media] ccm
        JOIN Media m ON m.mediaId = ccm.mediaId
        WHERE ccm.collectionId = @collectionId
        GROUP BY m.genre
    );
GO

SELECT * FROM dbo.getCollectionGenreCounts(3);
GO

-- 3. Create 3 views :- For your project create three views for any 3 tables

-- Displays all media stored in our database with their unique properties
-- NULL values for the properties which do not apply to a media type
CREATE VIEW vw_Media AS
    SELECT
        Media.[name],
        Media.overview,
        Media.release_date,
        Media.genre,
        Media.[type],
        Movies.rating AS movieRaing,
        Movies.leadActor,
        Movies.leadActorCharacter,
        Movies.supportingActor,
        Movies.supportingActorCharacter,
        Movies.director,
        Games.publisher AS gamePublisher,
        Games.platform,
        Games.metacritic,
        Games.esrbRating,
        Tv.[language],
        Tv.rating AS tvRating,
        Tv.numberOfEpisodes,
        Tv.numberOfSeasons,
        Tv.[status],
        Tv.network,
        Music.artist,
        Music.songDuration,
        Music.producer,
        Music.recordLabel,
        Books.publisher AS bookPublisher,
        Books.author,
        Books.maturity_rating,
        Books.page_count,
        Books.isbn
    FROM Media
    LEFT JOIN Books ON Books.mediaId = Media.mediaId
    LEFT JOIN Music ON Music.mediaId = Media.mediaId
    LEFT JOIN Tv ON Tv.mediaId = Media.mediaId
    LEFT JOIN Games ON Games.mediaId = Media.mediaId
    LEFT JOIN Movies ON Media.mediaId = Movies.mediaId;
GO

SELECT * FROM vw_Media;
GO

-- Shows user reviews grouped by user
CREATE VIEW vw_UserReviews AS
    SELECT
        [user].email,
        [user].firstName,
        [user].lastName,
        Review_for.mediaId,
        Review.rating,
        Review.reviewTitle,
        Review.reviewText,
        Review_for.reviewedAt
    FROM [user]
    JOIN Review_for ON [user].id = Review_for.userId
    JOIN Review ON Review_for.reviewId = Review.reviewId;
GO

SELECT * FROM vw_UserReviews;
GO

-- Shows user collections grouped by user
CREATE VIEW vw_UserCollections AS
    SELECT
        [user].email,
        [user].firstName,
        [user].lastName,
        [User_Creates_Collection].dateCreated,
        [Collection_tags].tag,
        [Collection].collectionName,
        [Collection].collectionDesc
    FROM[user]
    LEFT JOIN [User_Creates_Collection] ON [User_Creates_Collection].userId = [user].id
    LEFT JOIN [Collection] ON [Collection].collectionId = [User_Creates_Collection].collectionId
    LEFT JOIN [Collection_tags] ON [Collection_tags].collectionId = [Collection].collectionId;
GO

SELECT * FROM vw_UserCollections;
GO

-- 4. Create 1 Trigger :- For your project create one Trigger associated with any type of action
-- between the referenced tables(primary-foreign key relationship tables)

-- This trigger ensures that when a new review is added to the database
-- the same user is not allowed to review the same media item more 
-- than one time.
CREATE TRIGGER trg_UserSingleReview
    ON Review_for
    INSTEAD OF INSERT
    AS 
    BEGIN
        DECLARE @userId INT, @mediaId INT, @reviewId INT;

        SELECT @userId = userId, @mediaId = mediaId, @reviewId = reviewId FROM inserted;

        IF EXISTS(
            SELECT 1 FROM Review_for WHERE userId = @userId AND mediaId = @mediaId
        )
        BEGIN
            RAISERROR('This user has already written a review for this media', 16, 1);
            DELETE FROM Review WHERE reviewId = @reviewId;
        END
        ELSE
        BEGIN
            INSERT INTO Review_for (reviewId, userId, mediaId, reviewedAt)
            SELECT reviewId, userId, mediaId, reviewedAt FROM inserted;
        END
    END;
GO

-- 6. Create 3 non-clustered indexes :- create 3 non-clustered indexes on your tables.

-- This index will allow fast lookup of media by name
CREATE NONCLUSTERED INDEX idx_MediaName on Media([name]);

-- This index will allow quick lookup of all the review for a particular media
CREATE NONCLUSTERED INDEX idx_MediaIdForReview on Review_for(mediaId);

-- This index will allow fast lookup of all the collections a particular user has created
CREATE NONCLUSTERED INDEX idx_UsersCollections on [User_Creates_Collection](userId);