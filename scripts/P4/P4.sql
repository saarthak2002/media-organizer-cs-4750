USE MediaOrganizerApp;
GO

-- 5. Implement 1 Column Encryption :- For any 1 column in your table, implement the column
-- encryption for security purposes
-- Note: Modify passwordHash to VARBINARY(256) in [user] table

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
    @password = '789',
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

-- 3. Create 3 views :- For your project create three views for any 3 tables

-- 4. Create 1 Trigger :- For your project create one Trigger associated with any type of action
-- between the referenced tables(primary-foreign key relationship tables)

-- 6. Create 3 non-clustered indexes :- create 3 non-clustered indexes on your tables.