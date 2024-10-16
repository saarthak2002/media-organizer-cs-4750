CREATE DATABASE MediaOrganizerApp;

USE MediaOrganizerApp;
GO

CREATE TABLE [user] ( 
    id INT IDENTITY(1,1) PRIMARY KEY, 
    email NVARCHAR(255) UNIQUE NOT NULL, 
    passwordHash NVARCHAR(255) NOT NULL,
    firstName NVARCHAR(255) NOT NULL,
    lastName NVARCHAR(255) NOT NULL,
);

CREATE TABLE [Collection] (
    collectionId INT IDENTITY(1, 1) PRIMARY KEY,
    collectionName NVARCHAR(255),
    collectionDesc TEXT
);

CREATE TABLE [Collection_tags] (
    collectionId INT,
    tag NVARCHAR(100),
    CONSTRAINT Collection_tags_PK PRIMARY KEY (collectionId, tag),
    CONSTRAINT Collection_tags_FK FOREIGN KEY (collectionId) REFERENCES [Collection] (collectionId)
);

CREATE TABLE [User_Creates_Collection] (
    collectionId INT NOT NULL,
    userId INT NOT NULL,
    dateCreated DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT User_Creates_Collection_PK PRIMARY KEY (collectionId),
    CONSTRAINT User_Creates_Collection_FK1 FOREIGN KEY (collectionId) REFERENCES [Collection] (collectionId),
    CONSTRAINT User_Creates_Collection_FK2 FOREIGN KEY (userId) REFERENCES [user] (id)
);

CREATE TABLE Media  (
    mediaId INT NOT NULL,
    [name] NVARCHAR(255) NOT NULL,
    overview TEXT,
    poster_path TEXT,
    release_date DATE,
    genre NVARCHAR(255),
    [type] NVARCHAR(10),
    CONSTRAINT Media_PK PRIMARY KEY (mediaId),
    CONSTRAINT type_check CHECK ([type] IN ('MOVIE', 'TV', 'GAME', 'BOOK', 'MUSIC')),
);

CREATE TABLE [Collection_contains_Media] (
    collectionId INT NOT NULL,
    mediaId INT NOT NULL,
    dateAdded DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT Collection_contains_Media_PK PRIMARY KEY (collectionId, mediaId),
    CONSTRAINT Collection_contains_Media_FK1 FOREIGN KEY (collectionId) REFERENCES [Collection] (collectionId),
    CONSTRAINT Collection_contains_Media_FK2 FOREIGN KEY (mediaId) REFERENCES [Media] (mediaId)
);

CREATE TABLE Movies (
    mediaId INT NOT NULL,
    [language] NVARCHAR(2),
    rating DECIMAL DEFAULT 0,
    leadActor NVARCHAR(255),
    leadActorCharacter NVARCHAR(255),
    supportingActor NVARCHAR(255),
    supportingActorCharacter NVARCHAR(255),
    director NVARCHAR(255),
    CONSTRAINT Movies_PK PRIMARY KEY (mediaId),
    CONSTRAINT Movies_FK FOREIGN KEY (mediaId) REFERENCES Media(mediaId),
    CONSTRAINT language_check CHECK ([language] IN ('en', 'ko', 'ja', 'es', 'de'))
);

CREATE TABLE Games (
    mediaId INT NOT NULL,
    publisher NVARCHAR(255),
    platform NVARCHAR(255),
    metacritic DECIMAL DEFAULT 0,
    esrbRating NVARCHAR(255),
    CONSTRAINT Games_PK PRIMARY KEY (mediaId),
    CONSTRAINT Games_FK FOREIGN KEY (mediaId) REFERENCES Media(mediaId),
    CONSTRAINT Games_esrb_rating_check CHECK ([esrbRating] IN ('Mature', 'Everyone 10+', 'Everyone', 'Not Rated', 'Teen'))
);

CREATE TABLE Tv (
    mediaId INT NOT NULL,
    [language] NVARCHAR(2),
    rating DECIMAL DEFAULT 0,
    numberOfEpisodes INT,
    numberOfSeasons INT,
    [status] NVARCHAR(32),
    network NVARCHAR(32),
    CONSTRAINT Tv_PK PRIMARY KEY (mediaId),
    CONSTRAINT Tv_FK FOREIGN KEY (mediaId) REFERENCES Media(mediaId),
    CONSTRAINT Tv_status_check CHECK ([status] IN ('Ended', 'Returning Series', 'Canceled')),
    CONSTRAINT Tv_language_check CHECK ([language] IN ('en', 'ko', 'ja', 'es', 'de'))
);

CREATE TABLE Music (
    mediaId INT NOT NULL,
    artist NVARCHAR(255),
    songDuration INT,
    producer NVARCHAR(255),
    recordLabel NVARCHAR(255),
    CONSTRAINT Music_PK PRIMARY KEY (mediaId),
    CONSTRAINT Music_FK FOREIGN KEY (mediaId) REFERENCES Media(mediaId)
)

CREATE TABLE Books (
    mediaId INT NOT NULL,
    publisher NVARCHAR(255),
    author NVARCHAR(255),
    maturity_rating NVARCHAR(255),
    page_count INT,
    isbn BIGINT,
    CONSTRAINT Books_PK PRIMARY KEY (mediaId),
    CONSTRAINT Books_FK FOREIGN KEY (mediaId) REFERENCES Media(mediaId),
    CONSTRAINT Books_maturity_rating_check CHECK ([maturity_rating] IN ('NOT_MATURE', 'MATURE'))
);

CREATE TABLE Review (
    reviewId INT IDENTITY(1, 1) PRIMARY KEY,
    rating INT DEFAULT 1,
    reviewTitle NVARCHAR(255),
    reviewText TEXT,
    CONSTRAINT Review_rating_check CHECK (rating >= 1 AND rating <= 5)
);

CREATE TABLE Review_for (
    reviewId INT NOT NULL,
    userId INT NOT NULL,
    mediaId INT NOT NULL,
    reviewedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT Review_for_PK PRIMARY KEY (reviewId),
    CONSTRAINT Review_for_FK1 FOREIGN KEY (userId) REFERENCES [user] (id),
    CONSTRAINT Review_for_FK2 FOREIGN KEY (mediaId) REFERENCES [Media] (mediaId),
    CONSTRAINT Review_for_FK3 FOREIGN KEY (reviewId) REFERENCES [Review] (reviewId)
);

-- Insert Mock Data Into User Table
INSERT INTO [user] (email, passwordHash, firstName, lastName) VALUES
('user1@example.com', 'hashpassword1', 'John', 'Doe'),
('user2@example.com', 'hashpassword2', 'Jane', 'Smith'),
('user3@example.com', 'hashpassword3', 'Mike', 'Brown'),
('user4@example.com', 'hashpassword4', 'Alice', 'Johnson'),
('user5@example.com', 'hashpassword5', 'David', 'Williams'),
('user6@example.com', 'hashpassword6', 'Eva', 'Miller'),
('user7@example.com', 'hashpassword7', 'Chris', 'Davis'),
('user8@example.com', 'hashpassword8', 'Linda', 'Garcia'),
('user9@example.com', 'hashpassword9', 'Robert', 'Martinez'),
('user10@example.com', 'hashpassword10', 'Emma', 'Hernandez'),
('user11@example.com', 'hashpassword11', 'Oliver', 'Clark'),
('user12@example.com', 'hashpassword12', 'Sophia', 'Lewis'),
('user13@example.com', 'hashpassword13', 'Liam', 'Walker'),
('user14@example.com', 'hashpassword14', 'Isabella', 'Hall'),
('user15@example.com', 'hashpassword15', 'Lucas', 'Allen'),
('user16@example.com', 'hashpassword16', 'Mia', 'Young'),
('user17@example.com', 'hashpassword17', 'Ethan', 'King'),
('user18@example.com', 'hashpassword18', 'Ava', 'Scott'),
('user19@example.com', 'hashpassword19', 'Henry', 'Green'),
('user20@example.com', 'hashpassword20', 'Charlotte', 'Adams'),
('user21@example.com', 'hashpassword21', 'James', 'Baker'),
('user22@example.com', 'hashpassword22', 'Amelia', 'Gonzalez'),
('user23@example.com', 'hashpassword23', 'Benjamin', 'Nelson'),
('user24@example.com', 'hashpassword24', 'Ella', 'Carter'),
('user25@example.com', 'hashpassword25', 'Sebastian', 'Mitchell'),
('user26@example.com', 'hashpassword26', 'Emily', 'Perez'),
('user27@example.com', 'hashpassword27', 'Jack', 'Roberts'),
('user28@example.com', 'hashpassword28', 'Harper', 'Turner'),
('user29@example.com', 'hashpassword29', 'Nathan', 'Phillips'),
('user30@example.com', 'hashpassword30', 'Zoe', 'Campbell');

-- Insert Mock data into collection Table
INSERT INTO [Collection] (collectionName, collectionDesc) VALUES
('Nature Photography', 'A collection of beautiful nature photographs.'),
('Classic Literature', 'A collection of timeless literary works.'),
('Tech Gadgets', 'Latest and greatest in technology and gadgets.'),
('World Recipes', 'Delicious recipes from around the world.'),
('Space Exploration', 'Information and images related to space exploration.'),
('Art History', 'A dive into the history of art.'),
('Coding Tutorials', 'Helpful coding tutorials for beginners and experts.'),
('Fitness Guides', 'Workouts and guides for staying fit.'),
('DIY Crafts', 'Creative do-it-yourself craft ideas.'),
('Gaming News', 'Latest updates in the gaming world.'),
('Vintage Cars', 'A showcase of vintage automobiles.'),
('Meditation Techniques', 'Guides to help with meditation and mindfulness.'),
('Modern Architecture', 'Stunning examples of modern architecture.'),
('Wildlife Conservation', 'Efforts and news related to wildlife conservation.'),
('Music Reviews', 'Reviews and critiques of popular music.'),
('Photography Tips', 'Tips and tricks for aspiring photographers.'),
('Travel Destinations', 'Top travel destinations around the world.'),
('Fashion Trends', 'Latest trends in the fashion industry.'),
('Healthy Recipes', 'Nutritious and easy-to-make recipes.'),
('Science Innovations', 'Recent innovations in the field of science.'),
('Historical Events', 'A deep dive into key historical events.'),
('Home Decor', 'Ideas for decorating your home.'),
('Crypto Insights', 'Analysis and news about cryptocurrencies.'),
('Classic Movies', 'Reviews and recommendations for classic films.'),
('Gardening Tips', 'Advice for starting and maintaining a garden.'),
('Self-Help Books', 'Must-read self-help books for personal growth.'),
('Fantasy Novels', 'A collection of popular fantasy books.'),
('Programming Languages', 'Overview of different programming languages.'),
('Mental Health', 'Resources and tips for maintaining mental well-being.'),
('Startup Success', 'Stories and lessons from successful startups.');

-- Create Mock Data For the Collection_tags table
INSERT INTO [Collection_tags] (collectionId, tag) VALUES
(1, 'nature'), (1, 'photography'), (1, 'outdoor'),
(2, 'literature'), (2, 'classic'), (2, 'books'),
(3, 'tech'), (3, 'gadgets'), (3, 'innovation'),
(4, 'food'), (4, 'recipes'), (4, 'cooking'),
(5, 'space'), (5, 'exploration'), (5, 'astronomy'),
(6, 'art'), (6, 'history'), (6, 'culture'),
(7, 'coding'), (7, 'programming'), (7, 'tutorials'),
(8, 'fitness'), (8, 'health'), (8, 'exercise'),
(9, 'crafts'), (9, 'diy'), (9, 'creative'),
(10, 'gaming'), (10, 'news'), (10, 'entertainment'),
(11, 'cars'), (11, 'vintage'), (11, 'automobiles'),
(12, 'meditation'), (12, 'mindfulness'), (12, 'wellness'),
(13, 'architecture'), (13, 'design'), (13, 'modern'),
(14, 'wildlife'), (14, 'conservation'), (14, 'environment'),
(15, 'music'), (15, 'reviews'), (15, 'entertainment'),
(16, 'photography'), (16, 'tips'), (16, 'guides'),
(17, 'travel'), (17, 'destinations'), (17, 'explore'),
(18, 'fashion'), (18, 'trends'), (18, 'style'),
(19, 'health'), (19, 'recipes'), (19, 'nutrition'),
(20, 'science'), (20, 'innovation'), (20, 'research'),
(21, 'history'), (21, 'events'), (21, 'learning'),
(22, 'home'), (22, 'decor'), (22, 'design'),
(23, 'crypto'), (23, 'insights'), (23, 'finance'),
(24, 'movies'), (24, 'classic'), (24, 'reviews'),
(25, 'gardening'), (25, 'tips'), (25, 'plants'),
(26, 'books'), (26, 'self-help'), (26, 'growth'),
(27, 'fantasy'), (27, 'novels'), (27, 'books'),
(28, 'programming'), (28, 'languages'), (28, 'coding'),
(29, 'mental'), (29, 'health'), (29, 'wellbeing'),
(30, 'startup'), (30, 'success'), (30, 'business');

-- Mock data for what collections users have created
INSERT INTO [User_Creates_Collection] (collectionId, userId, dateCreated) VALUES
(1, 1, '2024-01-01'),
(2, 2, '2024-01-02'),
(3, 3, '2024-01-03'),
(4, 4, '2024-01-04'),
(5, 5, '2024-01-05'),
(6, 6, '2024-01-06'),
(7, 7, '2024-01-07'),
(8, 8, '2024-01-08'),
(9, 9, '2024-01-09'),
(10, 10, '2024-01-10'),
(11, 11, '2024-01-11'),
(12, 12, '2024-01-12'),
(13, 13, '2024-01-13'),
(14, 14, '2024-01-14'),
(15, 15, '2024-01-15'),
(16, 16, '2024-01-16'),
(17, 17, '2024-01-17'),
(18, 18, '2024-01-18'),
(19, 19, '2024-01-19'),
(20, 20, '2024-01-20'),
(21, 21, '2024-01-21'),
(22, 22, '2024-01-22'),
(23, 23, '2024-01-23'),
(24, 24, '2024-01-24'),
(25, 25, '2024-01-25'),
(26, 26, '2024-01-26'),
(27, 27, '2024-01-27'),
(28, 28, '2024-01-28'),
(29, 29, '2024-01-29'),
(30, 30, '2024-01-30');


-- Insert Values into Media Table
INSERT INTO Media VALUES(0, 'Moonlight', 'The tender, heartbreaking story of a young man’s struggle to find himself, told across three defining chapters in his life as he experiences the ecstasy, pain, and beauty of falling in love, while grappling with his own sexuality.', 'https://image.tmdb.org/t/p/original/4911T5FbJ9eD2Faz5Z8cT3SUhU3.jpg', '2016-10-21', 'Drama', 'MOVIE');
INSERT INTO Media VALUES(1, 'Joker', 'During the 1980s, a failed stand-up comedian is driven insane and turns to a life of crime and chaos in Gotham City while becoming an infamous psychopathic crime figure.', 'https://image.tmdb.org/t/p/original/udDclJoHjfjb8Ekgsd4FDteOkCU.jpg', '2019-10-01', 'Crime', 'MOVIE');
INSERT INTO Media VALUES(2, 'Dunkirk', 'The story of the miraculous evacuation of Allied soldiers from Belgium, Britain, Canada and France, who were cut off and surrounded by the German army from the beaches and harbour of Dunkirk between May 26th and June 4th 1940 during World War II.', 'https://image.tmdb.org/t/p/original/b4Oe15CGLL61Ped0RAS9JpqdmCt.jpg', '2017-07-19', 'War', 'MOVIE');
INSERT INTO Media VALUES(3, 'Parasite', 'Paul Dean has created a deadly parasite that is now attached to his stomach. He and his female companion, Patricia Welles, must find a way to destroy it while also trying to avoid Ricus & his rednecks, and an evil government agent named Merchant.', 'https://image.tmdb.org/t/p/original/krhU4toMvIVgZXZIyrlpuW1DwP9.jpg', '1982-03-12', 'Horror', 'MOVIE');
INSERT INTO Media VALUES(4, 'Her', 'In the not so distant future, Theodore, a lonely writer, purchases a newly developed operating system designed to meet the user''s every need. To Theodore''s surprise, a romantic relationship develops between him and his operating system. This unconventional love story blends science fiction and romance in a sweet tale that explores the nature of love and the ways that technology isolates and connects us all.', 'https://image.tmdb.org/t/p/original/lEIaL12hSkqqe83kgADkbUqEnvk.jpg', '2013-12-18', 'Romance', 'MOVIE');
INSERT INTO Media VALUES(5, 'The Shape of Water', 'An other-worldly story, set against the backdrop of Cold War era America circa 1962, where a mute janitor working at a lab falls in love with an amphibious man being held captive there and devises a plan to help him escape.', 'https://image.tmdb.org/t/p/original/9zfwPffUXpBrEP26yp0q1ckXDcj.jpg', '2017-12-01', 'Drama', 'MOVIE');
INSERT INTO Media VALUES(6, 'The Social Network', 'The tale of a new breed of cultural insurgent: a punk genius who sparked a revolution and changed the face of human interaction for a generation, and perhaps forever. Chronicling the formation of Facebook and the battles over ownership that followed upon the website''s unfathomable success, The Social Network bears witness to the birth of an idea that rewove the fabric of society even as it unraveled the friendship of its creators.', 'https://image.tmdb.org/t/p/original/n0ybibhJtQ5icDqTp8eRytcIHJx.jpg', '2010-10-01', 'Drama', 'MOVIE');
INSERT INTO Media VALUES(7, 'Gladiator', 'In the year 180, the death of emperor Marcus Aurelius throws the Roman Empire into chaos.  Maximus is one of the Roman army''s most capable and trusted generals and a key advisor to the emperor.  As Marcus'' devious son Commodus ascends to the throne, Maximus is set to be executed.  He escapes, but is captured by slave traders.  Renamed Spaniard and forced to become a gladiator, Maximus must battle to the death with other men for the amusement of paying audiences.', 'https://image.tmdb.org/t/p/original/ty8TGRuvJLPUmAR1H1nRIsgwvim.jpg', '2000-05-04', 'Action', 'MOVIE');
INSERT INTO Media VALUES(8, '12 Years a Slave', 'In the pre-Civil War United States, Solomon Northup, a free black man from upstate New York, is abducted and sold into slavery. Facing cruelty as well as unexpected kindnesses Solomon struggles not only to stay alive, but to retain his dignity. In the twelfth year of his unforgettable odyssey, Solomon’s chance meeting with a Canadian abolitionist will forever alter his life.', 'https://image.tmdb.org/t/p/original/xdANQijuNrJaw1HA61rDccME4Tm.jpg', '2013-10-18', 'Drama', 'MOVIE');
INSERT INTO Media VALUES(9, 'The Lord of the Rings: The Return of the King', 'As armies mass for a final battle that will decide the fate of the world--and powerful, ancient forces of Light and Dark compete to determine the outcome--one member of the Fellowship of the Ring is revealed as the noble heir to the throne of the Kings of Men. Yet, the sole hope for triumph over evil lies with a brave hobbit, Frodo, who, accompanied by his loyal friend Sam and the hideous, wretched Gollum, ventures deep into the very dark heart of Mordor on his seemingly impossible quest to destroy the Ring of Power.​', 'https://image.tmdb.org/t/p/original/rCzpDGLbOoPwLjy3OAm5NUPOTrC.jpg', '2003-12-17', 'Adventure', 'MOVIE');
INSERT INTO Media VALUES(10, 'The Revenant', 'In the 1820s, a frontiersman, Hugh Glass, sets out on a path of vengeance against those who left him for dead after a bear mauling.', 'https://image.tmdb.org/t/p/original/tSaBkriE7TpbjFoQUFXuikoz0dF.jpg', '2015-12-25', 'Western', 'MOVIE');
INSERT INTO Media VALUES(11, 'Whiplash', 'Under the direction of a ruthless instructor, a talented young drummer begins to pursue perfection at any cost, even his humanity.', 'https://image.tmdb.org/t/p/original/7fn624j5lj3xTme2SgiLCeuedmO.jpg', '2014-10-10', 'Drama', 'MOVIE');
INSERT INTO Media VALUES(12, 'Get Out', 'Chris and his girlfriend Rose go upstate to visit her parents for the weekend. At first, Chris reads the family''s overly accommodating behavior as nervous attempts to deal with their daughter''s interracial relationship, but as the weekend progresses, a series of increasingly disturbing discoveries lead him to a truth that he never could have imagined.', 'https://image.tmdb.org/t/p/original/tFXcEccSQMf3lfhfXKSU9iRBpa3.jpg', '2017-02-24', 'Mystery', 'MOVIE');
INSERT INTO Media VALUES(13, 'Inception', 'Cobb, a skilled thief who commits corporate espionage by infiltrating the subconscious of his targets is offered a chance to regain his old life as payment for a task considered to be impossible: "inception", the implantation of another person''s idea into a target''s subconscious.', 'https://image.tmdb.org/t/p/original/ljsZTbVsrQSqZgWeep2B1QiDKuh.jpg', '2010-07-15', 'Action', 'MOVIE');
INSERT INTO Media VALUES(14, 'Dune', 'Paul Atreides, a brilliant and gifted young man born into a great destiny beyond his understanding, must travel to the most dangerous planet in the universe to ensure the future of his family and his people. As malevolent forces explode into conflict over the planet''s exclusive supply of the most precious resource in existence-a commodity capable of unlocking humanity''s greatest potential-only those who can conquer their fear will survive.', 'https://image.tmdb.org/t/p/original/d5NXSklXo0qyIYkgV94XAgMIckC.jpg', '2021-09-15', 'Science Fiction', 'MOVIE');
INSERT INTO Media VALUES(15, 'Birdman', 'A portrait of Robert, a troubled but poetic soul struggling with his purgatorial existence in a hackney scrapyard.', 'https://image.tmdb.org/t/p/original/9n0u3Ee7OUjgeyF5kIwahxkf4xm.jpg', '2015-07-01', 'Documentary', 'MOVIE');
INSERT INTO Media VALUES(16, 'La La Land', 'Mia, an aspiring actress, serves lattes to movie stars in between auditions and Sebastian, a jazz musician, scrapes by playing cocktail party gigs in dingy bars, but as success mounts they are faced with decisions that begin to fray the fragile fabric of their love affair, and the dreams they worked so hard to maintain in each other threaten to rip them apart.', 'https://image.tmdb.org/t/p/original/uDO8zWDhfWwoFdKS4fzkUJt0Rf0.jpg', '2016-11-29', 'Comedy', 'MOVIE');
INSERT INTO Media VALUES(17, 'A Star Is Born', 'Seasoned musician Jackson Maine discovers — and falls in love with — struggling artist Ally. She has just about given up on her dream to make it big as a singer — until Jack coaxes her into the spotlight. But even as Ally''s career takes off, the personal side of their relationship is breaking down, as Jack fights an ongoing battle with his own internal demons.', 'https://image.tmdb.org/t/p/original/wrFpXMNBRj2PBiN4Z5kix51XaIZ.jpg', '2018-10-03', 'Music', 'MOVIE');
INSERT INTO Media VALUES(18, 'Everything Everywhere All at Once', 'An aging Chinese immigrant is swept up in an insane adventure, where she alone can save what''s important to her by connecting with the lives she could have led in other universes.', 'https://image.tmdb.org/t/p/original/rKvCys0fMIIi1X9rmJBxTPLAtoU.jpg', '2022-03-24', 'Action', 'MOVIE');
INSERT INTO Media VALUES(19, 'The Irishman', 'Pennsylvania, 1956. Frank Sheeran, a war veteran of Irish origin who works as a truck driver, accidentally meets mobster Russell Bufalino. Once Frank becomes his trusted man, Bufalino sends him to Chicago with the task of helping Jimmy Hoffa, a powerful union leader related to organized crime, with whom Frank will maintain a close friendship for nearly twenty years.', 'https://image.tmdb.org/t/p/original/mbm8k3GFhXS0ROd9AD1gqYbIFbM.jpg', '2019-11-01', 'Crime', 'MOVIE');
INSERT INTO Media VALUES(20, 'Top Gun: Maverick', 'After more than thirty years of service as one of the Navy’s top aviators, and dodging the advancement in rank that would ground him, Pete “Maverick” Mitchell finds himself training a detachment of TOP GUN graduates for a specialized mission the likes of which no living pilot has ever seen.', 'https://image.tmdb.org/t/p/original/62HCnUTziyWcpDaBO2i1DX17ljH.jpg', '2022-05-21', 'Action', 'MOVIE');
INSERT INTO Media VALUES(21, 'Arrival', 'Taking place after alien crafts land around the world, an expert linguist is recruited by the military to determine whether they come in peace or are a threat.', 'https://image.tmdb.org/t/p/original/pEzNVQfdzYDzVK0XqxERIw2x2se.jpg', '2016-11-10', 'Drama', 'MOVIE');
INSERT INTO Media VALUES(22, 'Black Panther', 'King T''Challa returns home to the reclusive, technologically advanced African nation of Wakanda to serve as his country''s new leader. However, T''Challa soon finds that he is challenged for the throne by factions within his own country as well as without. Using powers reserved to Wakandan kings, T''Challa assumes the Black Panther mantle to join with ex-girlfriend Nakia, the queen-mother, his princess-kid sister, members of the Dora Milaje (the Wakandan ''special forces'') and an American secret agent, to prevent Wakanda from being dragged into a world war.', 'https://image.tmdb.org/t/p/original/uxzzxijgPIY7slzFvMotPv8wjKA.jpg', '2018-02-13', 'Action', 'MOVIE');
INSERT INTO Media VALUES(23, 'Avengers: Endgame', 'After the devastating events of Avengers: Infinity War, the universe is in ruins due to the efforts of the Mad Titan, Thanos. With the help of remaining allies, the Avengers must assemble once more in order to undo Thanos'' actions and restore order to the universe once and for all, no matter what consequences may be in store.', 'https://image.tmdb.org/t/p/original/or06FN3Dka5tukK1e9sl16pB3iy.jpg', '2019-04-24', 'Adventure', 'MOVIE');
INSERT INTO Media VALUES(24, 'Blade Runner 2049', 'Thirty years after the events of the first film, a new blade runner, LAPD Officer K, unearths a long-buried secret that has the potential to plunge what''s left of society into chaos. K''s discovery leads him on a quest to find Rick Deckard, a former LAPD blade runner who has been missing for 30 years.', 'https://image.tmdb.org/t/p/original/gajva2L0rPYkEWjzgFlBXCAVBE5.jpg', '2017-10-04', 'Science Fiction', 'MOVIE');
INSERT INTO Media VALUES(25, 'Inside Out 2', 'Teenager Riley''s mind headquarters is undergoing a sudden demolition to make room for something entirely unexpected: new Emotions! Joy, Sadness, Anger, Fear and Disgust, who’ve long been running a successful operation by all accounts, aren’t sure how to feel when Anxiety shows up. And it looks like she’s not alone.', 'https://image.tmdb.org/t/p/original/vpnVM9B6NMmQpWeZvzLvDESb2QY.jpg', '2024-06-11', 'Animation', 'MOVIE');
INSERT INTO Media VALUES(26, 'No Country for Old Men', 'Llewelyn Moss stumbles upon dead bodies, $2 million and a hoard of heroin in a Texas desert, but methodical killer Anton Chigurh comes looking for it, with local sheriff Ed Tom Bell hot on his trail. The roles of prey and predator blur as the violent pursuit of money and justice collide.', 'https://image.tmdb.org/t/p/original/bj1v6YKF8yHqA489VFfnQvOJpnc.jpg', '2007-06-13', 'Crime', 'MOVIE');
INSERT INTO Media VALUES(27, 'The Dark Knight', 'Batman raises the stakes in his war on crime. With the help of Lt. Jim Gordon and District Attorney Harvey Dent, Batman sets out to dismantle the remaining criminal organizations that plague the streets. The partnership proves to be effective, but they soon find themselves prey to a reign of chaos unleashed by a rising criminal mastermind known to the terrified citizens of Gotham as the Joker.', 'https://image.tmdb.org/t/p/original/qJ2tW6WMUDux911r6m7haRef0WH.jpg', '2008-07-16', 'Drama', 'MOVIE');
INSERT INTO Media VALUES(28, 'Jojo Rabbit', 'A World War II satire that follows a lonely German boy whose world view is turned upside down when he discovers his single mother is hiding a young Jewish girl in their attic. Aided only by his idiotic imaginary friend, Adolf Hitler, Jojo must confront his blind nationalism.', 'https://image.tmdb.org/t/p/original/7GsM4mtM0worCtIVeiQt28HieeN.jpg', '2019-10-18', 'Comedy', 'MOVIE');
INSERT INTO Media VALUES(29, 'Mad Max: Fury Road', 'An apocalyptic story set in the furthest reaches of our planet, in a stark desert landscape where humanity is broken, and most everyone is crazed fighting for the necessities of life. Within this world exist two rebels on the run who just might be able to restore order.', 'https://image.tmdb.org/t/p/original/hA2ple9q4qnwxp3hKVNhroipsir.jpg', '2015-05-13', 'Action', 'MOVIE');
INSERT INTO Media VALUES(30, 'Avatar', 'In the 22nd century, a paraplegic Marine is dispatched to the moon Pandora on a unique mission, but becomes torn between following orders and protecting an alien civilization.', 'https://image.tmdb.org/t/p/original/kyeqWdyUXW608qlYkRqosgbbJyK.jpg', '2009-12-15', 'Action', 'MOVIE');
INSERT INTO Media VALUES(31, 'The Grand Budapest Hotel', 'The Grand Budapest Hotel tells of a legendary concierge at a famous European hotel between the wars and his friendship with a young employee who becomes his trusted protégé. The story involves the theft and recovery of a priceless Renaissance painting, the battle for an enormous family fortune and the slow and then sudden upheavals that transformed Europe during the first half of the 20th century.', 'https://image.tmdb.org/t/p/original/eWdyYQreja6JGCzqHWXpWHDrrPo.jpg', '2014-02-26', 'Comedy', 'MOVIE');
INSERT INTO Media VALUES(32, 'The Wolf of Wall Street', 'A New York stockbroker refuses to cooperate in a large securities fraud case involving corruption on Wall Street, corporate banking world and mob infiltration. Based on Jordan Belfort''s autobiography.', 'https://image.tmdb.org/t/p/original/34m2tygAYBGqA9MXKhRDtzYd4MR.jpg', '2013-12-25', 'Crime', 'MOVIE');
INSERT INTO Media VALUES(33, 'Spider-Man: Into the Spider-Verse', 'Struggling to find his place in the world while juggling school and family, Brooklyn teenager Miles Morales is unexpectedly bitten by a radioactive spider and develops unfathomable powers just like the one and only Spider-Man. While wrestling with the implications of his new abilities, Miles discovers a super collider created by the madman Wilson "Kingpin" Fisk, causing others from across the Spider-Verse to be inadvertently transported to his dimension.', 'https://image.tmdb.org/t/p/original/iiZZdoQBEYBv6id8su7ImL0oCbD.jpg', '2018-12-06', 'Animation', 'MOVIE');
INSERT INTO Media VALUES(34, 'Interstellar', 'The adventures of a group of explorers who make use of a newly discovered wormhole to surpass the limitations on human space travel and conquer the vast distances involved in an interstellar voyage.', 'https://image.tmdb.org/t/p/original/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg', '2014-11-05', 'Adventure', 'MOVIE');
INSERT INTO Media VALUES(35, 'Ghost of Tsushima', 'The year is 1274. Samurai warriors are the legendary defenders of Japan--until the fearsome Mongol Empire invades the island of Tsushima, wreaking havoc and conquering the local population. As one of the last surviving samurai, you rise from the ashes to fight back. But, honorable tactics won''t lead you to victory. You must move beyond your samurai traditions to forge a new way of fighting--the way of the Ghost--as you wage an unconventional war for the freedom of Japan.', 'https://media.rawg.io/media/games/f24/f2493ea338fe7bd3c7d73750a85a0959.jpeg', '2020-07-17', 'Adventure', 'GAME');
INSERT INTO Media VALUES(36, 'Portal 2', 'Portal 2 is a first-person puzzle game developed by Valve Corporation and released on April 19, 2011 on Steam, PS3 and Xbox 360. It was published by Valve Corporation in digital form and by Electronic Arts in physical form.   Its plot directly follows the first game''s, taking place in the Half-Life universe. You play as Chell, a test subject in a research facility formerly ran by the company Aperture Science, but taken over by an evil AI that turned upon its creators, GladOS. After defeating GladOS at the end of the first game but failing to escape the facility, Chell is woken up from a stasis chamber by an AI personality core, Wheatley, as the unkempt complex is falling apart. As the two attempt to navigate through the ruins and escape, they stumble upon GladOS, and accidentally re-activate her...', 'https://media.rawg.io/media/games/2ba/2bac0e87cf45e5b508f227d281c9252a.jpg', '2011-04-18', 'Shooter', 'GAME');
INSERT INTO Media VALUES(37, 'God of War (2018)', 'It is a new beginning for Kratos. Living as a man outside the shadow of the gods, he ventures into the brutal Norse wilds with his son Atreus, fighting to fulfill a deeply personal quest.   His vengeance against the Gods of Olympus years behind him, Kratos now lives as a man in the realm of Norse Gods and monsters. It is in this harsh, unforgiving world that he must fight to survive… And teach his son to do the same. This startling reimagining of God of War deconstructs the core elements that defined the series—satisfying combat; breathtaking scale; and a powerful narrative—and fuses them anew. ', 'https://media.rawg.io/media/games/4be/4be6a6ad0364751a96229c56bf69be59.jpg', '2018-04-20', 'Action', 'GAME');
INSERT INTO Media VALUES(38, 'Super Mario Odyssey', 'Super Mario Odyssey is a 3D platform game, a part of Nintendo’s Super Mario series.   ###Story ', 'https://media.rawg.io/media/games/267/267bd0dbc496f52692487d07d014c061.jpg', '2017-10-27', 'Platformer', 'GAME');
INSERT INTO Media VALUES(39, 'Halo 3', 'Halo 3 is a first-person shooter from Bungie and another installment in one of the most popular gaming universes. The third part of the franchise completes the story begun in Halo: Combat Evolved.  The action takes place in years 2552-53, in which humanity colonized the distant boundaries of the universe and met the aliens The Covenant. As a result of the conflict, a war begins between two species. Play as the Master Chief, who suffers a crash in eastern Africa. He is found by his allies Johnson and the Arbiter and together they are sent to repel the alien aggressors.', 'https://media.rawg.io/media/games/982/982ff61d574fed5e416cb1867b40d9b0.jpg', '2007-09-25', 'Shooter', 'GAME');
INSERT INTO Media VALUES(40, 'Minecraft', 'One of the most popular games of the 2010s, Minecraft allows you to rebuild the environment around you. The world of the game is open, infinitely wide, and procedurally generated. It is composed of small 3D cubes that represent specific types of materials or terrain. The gameplay is centered on mining and building various structures of your choice. You can also craft items like tools, weapons, and armor. There''s an option to shift to the first or the third person view. Minecraft includes multiple modes that dramatically change the focus of the game. Survival and Adventure modes require the player to gather resources, hunt for food and fight monsters to survive. In the Hardcore mode, there’s even permanent death. Creative mode, by contrast, offers you to freely explore the world and construct whatever you want with unlimited resources. There’s also a multiplayer mode that allows the players to share their worlds and engage in the traditional MMO activities, such as player-vs-player combat. Minecraft’s crude visual style, reminiscent of Lego cubes, became an iconic part of the popular culture. There are many myths and fan fiction surrounding the game, such as the legend of Herobrine, a rumored character that officially doesn’t exist.', 'https://media.rawg.io/media/games/b4e/b4e4c73d5aa4ec66bbf75375c4847a2b.jpg', '2009-05-10', 'Action', 'GAME');
INSERT INTO Media VALUES(41, 'Call of Duty: Modern Warfare (2019)', 'The stakes have never been higher as players take on the role of lethal Tier One operators in a heart-racing saga that will affect the global balance of power. Call of Duty®: Modern Warfare® engulfs fans in an incredibly raw, gritty, provocative narrative that brings unrivaled intensity and shines a light on the changing nature of modern war. Developed by the studio that started it all, Infinity Ward delivers an epic reimagining of the iconic Modern Warfare® series from the ground up.', 'https://media.rawg.io/media/games/e43/e43f9f0a1429bd9332020ac5876bc693.jpg', '2019-10-25', 'Shooter', 'GAME');
INSERT INTO Media VALUES(42, 'The Elder Scrolls V: Skyrim', 'The fifth game in the series, Skyrim takes us on a journey through the coldest region of Cyrodiil. Once again player can traverse the open world RPG armed with various medieval weapons and magic, to become a hero of Nordic legends –Dovahkiin, the Dragonborn. After mandatory character creation players will have to escape not only imprisonment but a fire-breathing dragon. Something Skyrim hasn’t seen in centuries.', 'https://media.rawg.io/media/games/7cf/7cfc9220b401b7a300e409e539c9afd5.jpg', '2011-11-11', 'Action', 'GAME');
INSERT INTO Media VALUES(43, 'Among Us', 'Join your crewmates in a multiplayer game of teamwork and betrayal!  Play online or over local wifi with 4-10 players as you attempt to hold your spaceship together and return back to civilization. But beware...as there may be an alien impostor aboard!', 'https://media.rawg.io/media/games/e74/e74458058b35e01c1ae3feeb39a3f724.jpg', '2018-07-25', 'Casual', 'GAME');
INSERT INTO Media VALUES(44, 'Undertale', 'Undertale is an independent role-playing game developed by Toby Fox.  Once upon a time, there were two races on Earth: monsters and humans, but a war broke out between them and the latter won. Seven greatest mages sealed the monsters underground and left one entrance through a hole in the Ebott mountain. A lot of time passed since the war, but a human child accidentally falls down the mountain. Its goal is to get back out.', 'https://media.rawg.io/media/games/ffe/ffed87105b14f5beff72ff44a7793fd5.jpg', '2015-09-14', 'Indie', 'GAME');
INSERT INTO Media VALUES(45, 'Grand Theft Auto V', 'Rockstar Games went bigger, since their previous installment of the series. You get the complicated and realistic world-building from Liberty City of GTA4 in the setting of lively and diverse Los Santos, from an old fan favorite GTA San Andreas. 561 different vehicles (including every transport you can operate) and the amount is rising with every update.  Simultaneous storytelling from three unique perspectives:  Follow Michael, ex-criminal living his life of leisure away from the past, Franklin, a kid that seeks the better future, and Trevor, the exact past Michael is trying to run away from. ', 'https://media.rawg.io/media/games/20a/20aa03a10cda45239fe22d035c0ebe64.jpg', '2013-09-17', 'Action', 'GAME');
INSERT INTO Media VALUES(46, 'Fortnite Battle Royale', 'Fortnite Battle Royale is the completely free 100-player PvP mode in Fortnite. One giant map. A battle bus. Fortnite building skills and destructible environments combined with intense PvP combat. The last one standing wins.  Download now for FREE and jump into the action. This download also gives you a path to purchase the Save the World co-op PvE campaign during Fortnite’s Early Access season, or instant access if you received a Friend invite. Online features require an account and are subject to terms of service and applicable privacy policy (playstationnetwork.com/terms-of-service & playstationnetwork.com/privacy-policy).', 'https://media.rawg.io/media/games/dcb/dcbb67f371a9a28ea38ffd73ee0f53f3.jpg', '2017-09-26', 'Shooter', 'GAME');
INSERT INTO Media VALUES(47, 'Red Dead Redemption 2', 'America, 1899. The end of the wild west era has begun as lawmen hunt down the last remaining outlaw gangs. Those who will not surrender or succumb are killed.   After a robbery goes badly wrong in the western town of Blackwater, Arthur Morgan and the Van der Linde gang are forced to flee. With federal agents and the best bounty hunters in the nation massing on their heels, the gang must rob, steal and fight their way across the rugged heartland of America in order to survive. As deepening internal divisions threaten to tear the gang apart, Arthur must make a choice between his own ideals and loyalty to the gang who raised him.', 'https://media.rawg.io/media/games/511/5118aff5091cb3efec399c808f8c598f.jpg', '2018-10-26', 'Action', 'GAME');
INSERT INTO Media VALUES(48, 'Bloodborne', 'Bloodborne is an action-RPG and another member of souls-like title series. The game has no predecessors or successors, making it the only entry with one add-on: “The Old Hunters.” The Bloodborne universe, however, also includes a comics and a board game.  Generally resembling the Dark Souls series, Bloodborne, however, has some different mechanics and the pace of combat is increased thanks to the risk-rewarding battle system. Another difference is multiplayer, which comes in two kinds: you can summon other players into your game and fight bosses side by side or you can fight impostors, who are other players invading your playthrough.', 'https://media.rawg.io/media/games/214/214b29aeff13a0ae6a70fc4426e85991.jpg', '2015-03-24', 'Action', 'GAME');
INSERT INTO Media VALUES(49, 'Celeste', 'Celeste is a platformer about climbing a mountain, from the creators of TowerFall. Explore a sprawling mountain with over 500 levels bursting with secrets, across 8 unique areas. Unlock a hardcore Remix for each area, with completely new levels that will push your climbing skills to the limit. Madeline can air-dash and climb any surface to gain ground. Controls are simple and accessible, but super tight and expressive with layers of depth to master. Deaths are sudden and respawns are fast. You''ll die a lot, but you''ll learn something every time.', 'https://media.rawg.io/media/games/594/59487800889ebac294c7c2c070d02356.jpg', '2018-01-25', 'Platformer', 'GAME');
INSERT INTO Media VALUES(50, 'The Last Of Us', 'The population of the Earth almost disappeared as a result of a pandemic caused by a mutated fungus. The disease causes irreversible changes in the human body, a person loses his mind and behaves aggressively, like a zombie. Civilization no longer exists, few survivors live in isolation under the protection of the military. Cities outside the zones are dangerous ruins inhabited by infected people and people who have almost lost humanity. Heroes, the smuggler Joel and teenage girl Ellie, are trying to cross the continent, colliding in depopulated cities with all the set of dangers. The game requires hidden actions, the combat capability and the number of ammunition of the heroes are small, and it is best for them to avoid fighting. For most of the game, the player controls Joel, while Ellie and Joel''s other companions are controlled by artificial intelligence.', 'https://media.rawg.io/media/games/a5a/a5a7fb8d9cb8063a8b42ee002b410db6.jpg', '2013-06-14', 'Adventure', 'GAME');
INSERT INTO Media VALUES(51, 'Monster Hunter: World', 'Monster Hunter: World is the fifth game in the Japanese franchise Monster Hunter, which is about hunting giant beasts. It is set in a medieval fantasy setting, on a continent known as the New World that is being colonized by the humans from the Old World. The plot revolves around a dragon migration called Elder Crossing. Your protagonist is a hunter, whose name and appearance can be customized. You traveled from the Old World to study and hunt the dragons and other local monsters.   The hunter, accompanied by an assistant, starts at the city of Astera, from where they can freely wander the open world. There are six regions in the New World, each with its own base camp. The camps are where you have to thoroughly prepare before every expedition, gathering equipment and provision. Before you can fight monsters, they need to be tracked down using Scout flies and studied to discover their habits, strengths, and weaknesses. There are no character levels, so your hunter’s effectiveness relies on the hunting gear you have equipped. Advanced armor and weapons can be created using a detailed crating system. Many items that you found on missions, including body parts of monsters, can be used for crafting.', 'https://media.rawg.io/media/games/21c/21cc15d233117c6809ec86870559e105.jpg', '2018-01-26', 'Adventure', 'GAME');
INSERT INTO Media VALUES(52, 'Hades', 'Hades is a rogue-like dungeon crawler that combines the best aspects of Supergiant''s critically acclaimed titles, including the fast-paced action of Bastion, the rich atmosphere and depth of Transistor, and the character-driven storytelling of Pyre.  BATTLE OUT OF HELL', 'https://media.rawg.io/media/games/1f4/1f47a270b8f241e4676b14d39ec620f7.jpg', '2020-09-17', 'Indie', 'GAME');
INSERT INTO Media VALUES(53, 'Hollow Knight', 'Hollow Knight is a Metroidvania-type game developed by an indie studio named Team Cherry.  Most of the game''s story is told through the in-world items, tablets, and thoughts of other characters. Many plot aspects are told to the player indirectly or through the secret areas that provide a bit of lore in addition to an upgrade. At the beginning of the game, the player visits a town of Dirtmouth. A town built above the ruins of Hallownest. The players descend down into the ruins to find some answers to his questions.', 'https://media.rawg.io/media/games/4cf/4cfc6b7f1850590a4634b08bfab308ab.jpg', '2017-02-23', 'Platformer', 'GAME');
INSERT INTO Media VALUES(54, 'Persona 5', 'Persona series is a part of Japanese franchise Megami Tensei and is famous for its anime-like visual style. Persona 5 follows the unnamed main character, a high school student who was falsely accused of assault. He joins the Shujin Academy where he becomes the leading member of Phantom Thieves of Hearts. They are a gang of vigilantes who can to control their Personas and use them in a fight. The Personas are manifestations of people’s personalities that look like fictional characters. The Phantom Thieves accompany the main character in his battles as a party. The world of Persona consists of two parts. One is the modern Tokyo, in which the main characters live their daily teenagers’ lives. This is the place for most character interactions, including romancing. The other part is Metaverse, a parallel supernatural world that contains Palaces, which are manifestations of people’s malicious thoughts and desires. By day, the main character and his friends attend school and meet friends, and by night, they fight villains in the Metaverse to steal treasures from their Palaces. Battles are turn-based, and characters use a variety of weapons as well as their Personas that provide them with battle magic.', 'https://media.rawg.io/media/games/3ea/3ea0e57ede873970c0f1130e30d88749.jpg', '2016-09-15', 'Adventure', 'GAME');
INSERT INTO Media VALUES(55, 'Rocket League', 'Highly competitive soccer game with rocket-cars is the most comprehensive way to describe this game. Technically a sequel to Psyonix’ previous game - Supersonic Acrobatic Rocket-Powered Battle-Cars; Rocket League successfully became a standalone sensation, that can be enjoyed by anyone. Easy to learn, hard to master game mechanics are perfect for the tight controls. Players are invited to maneuver the different fields within several game modes, from arcade to ranked game either 1v1, or in 2v2 and 3v3 teams. Using boosters will not only speed up the car but will allow the car to propel itself into the air. Rocket League provides several levels of customization, where not only the color of your car can be adjusted, but the colors and form of the booster flame, different hats, and little flags. Or players can pick a completely different car. Collaboration with different franchises brought not only original transport but some famous cars, including Batmobile or Delorian from Back to the Future.', 'https://media.rawg.io/media/games/8cc/8cce7c0e99dcc43d66c8efd42f9d03e3.jpg', '2015-07-07', 'Racing', 'GAME');
INSERT INTO Media VALUES(56, 'Terraria', 'Terraria is a 2D action adventure sandbox game, where players create a character and gather resources in order to gradually craft stronger weapons and armor. Players create randomly generated maps that contain different locations within it, and by gathering specific resources and triggering special events, players will fight one of the many in-game bosses. Created characters can be played on different maps. The game introduces hundreds of unique items that can be found across the entirety of the map, some of which may not even be encountered.  Terraria have many different Biomes and areas with distinct visuals, containing resources and enemies unique to this biome. After gathering materials, players can craft furniture, and build settlements and houses, since after completing events or finding specific items NPCs will start to arrive, and will require player’s protection. Terraria can be played on three difficulties and has a large modding community.', 'https://media.rawg.io/media/games/f46/f466571d536f2e3ea9e815ad17177501.jpg', '2011-05-16', 'Platformer', 'GAME');
INSERT INTO Media VALUES(57, 'Elden Ring: Shadow of the Erdtree', 'The Land of Shadow.  A place obscured by the Erdtree.', 'https://media.rawg.io/media/screenshots/0ba/0bae7160eedc1f7d85a8d2db70cf1ec9.jpg', '2024-06-21', 'Action', 'GAME');
INSERT INTO Media VALUES(58, 'Mass Effect 2', 'Mass Effect II is a sequel to Mass Effect one, following the story of Captain Shepard in his or her journey in saving the Galaxy from Reapers. Just after the fight against Saren, Shepard dies and drifts in open space. Being collected by Cerberus and the lead man, The Illusive Man, Shepard has to investigate attacks on human colonies around the Milky Way, and discover that now the Reapers using some new insectoid called the Collectors.   You can choose from different classes to play, for example, a Soldier, Adept or Vanguard. A cover system is the main mechanic in the fight, as you have to think about fighting your enemy strategically. Your talents have a global CDR, so choose wisely. With one little addition, now your weapon has a loaded magazine of bullets, and you can run out of ammo if not using your weapon properly. ', 'https://media.rawg.io/media/games/3cf/3cff89996570cf29a10eb9cd967dcf73.jpg', '2010-01-26', 'Action', 'GAME');
INSERT INTO Media VALUES(59, 'Overwatch', '###The Legacy Overwatch is a multiplayer first-person shooter from the company that gave players the saga of Azeroth, Starcraft and the Diablo universe. Despite these releases coming out years ago, they are still alive and actively updated. But the developers at Blizzard wanted something new: the company does not like to experiment with new settings, preferring to transfer existing characters to new genres, worlds, and situations. The exception, perhaps, can only be a game about the three Vikings—The Lost Vikings, but this, too, was a long time ago. ', 'https://media.rawg.io/media/games/4ea/4ea507ceebeabb43edbc09468f5aaac6.jpg', '2016-05-24', 'Casual', 'GAME');
INSERT INTO Media VALUES(60, 'The Legend of Zelda: Breath of the Wild', 'The Legend of Zelda: Breath of the Wild is an adventure game developed by Nintendo. It is the nineteenth installment in the series.  After awakening from a hundred year sleep, memoryless Link hears a mysterious female voice that guides him to a destroyed kingdom of Hyrule. He finds a Wiseman who says that a ruthless creature, Calamity Ganon, was imprisoned for 100 years. Even though the creature is trapped, it is still gaining power. Link sets out to kill Ganon before he frees himself and destroys the world.', 'https://media.rawg.io/media/games/cc1/cc196a5ad763955d6532cdba236f730c.jpg', '2017-03-03', 'Adventure', 'GAME');
INSERT INTO Media VALUES(61, 'Dark Souls', 'Bone-rattling because of its complexity adventure in the Lordran, land of the ancient lords and endless mysteries. We are playing for a tacit prisoner, whose goal is to become human again. This is the first game in the series.  The main game mechanics is exploration. Dark Souls is a third-person action RPG, a part of the Souls series. The player slowly advances from one point of contact to another, defeating more and more powerful enemies. Completing the game is a truly hard task with the first, one of the main features of the series - a constant repetition and search for better tactics to overcome a certain enemy. After each savepoint respawns defeated enemies, after each death the player loses all the accumulated in-game currency.', 'https://media.rawg.io/media/games/582/582b5518a52f5086d15dde128264b94d.jpg', '2011-09-22', 'Action', 'GAME');
INSERT INTO Media VALUES(62, 'Animal Crossing: New Horizons', 'If the hustle and bustle of modern life’s got you down, Tom Nook has a new business venture up his sleeve that he knows you’ll adore: the Nook Inc. Deserted Island Getaway Package! Sure, you’ve crossed paths with colorful characters near and far. Had a grand time as one of the city folk. May’ve even turned over a new leaf and dedicated yourself to public service! But deep down, isn’t there a part of you that longs for…freedom? Then perhaps a long walk on the beach of a deserted island, where a rich wealth of untouched nature awaits, is just what the doctor ordered!  Peaceful creativity and charm await as you roll up your sleeves and make your new life whatever you want it to be. Collect resources and craft everything from creature comforts to handy tools. Embrace your green thumb as you interact with flowers and trees in new ways. Set up a homestead where the rules of what goes indoors and out no longer apply. Make friends with new arrivals, enjoy the seasons, pole-vault across rivers as you explore, and more!', 'https://media.rawg.io/media/games/42f/42fe1abd4d7c11ca92d93a0fb0f8662b.jpg', '2020-03-20', 'Simulation', 'GAME');
INSERT INTO Media VALUES(63, 'The Witcher 3: Wild Hunt', 'The third game in a series, it holds nothing back from the player. Open world adventures of the renowned monster slayer Geralt of Rivia are now even on a larger scale. Following the source material more accurately, this time Geralt is trying to find the child of the prophecy, Ciri while making a quick coin from various contracts on the side. Great attention to the world building above all creates an immersive story, where your decisions will shape the world around you.  CD Project Red are infamous for the amount of work they put into their games, and it shows, because aside from classic third-person action RPG base game they provided 2 massive DLCs with unique questlines and 16 smaller DLCs, containing extra quests and items.', 'https://media.rawg.io/media/games/618/618c2031a07bbff6b4f611f10b6bcdbc.jpg', '2015-05-18', 'Action', 'GAME');
INSERT INTO Media VALUES(64, 'Uncharted 4: A Thief’s End', 'Uncharted 4 is the final installment in the Uncharted series. The story follows Nathan Drake for the last time as he now searches for Captain Henry Avery''s treasure.   Introducing new characters such as Samuel Drake, with Sam and Sully Nathan agrees to find the treasure of the Gunsway heist in 1695. As antagonists, Nathan must face Rafe Adler and Nadine Ross while they are also trying to find this treasure and Nathan must face details about Sam''s past.', 'https://media.rawg.io/media/games/709/709bf81f874ce5d25d625b37b014cb63.jpg', '2016-05-10', 'Shooter', 'GAME');
INSERT INTO Media VALUES(65, 'Divinity: Original Sin 2', 'The Divine is dead. The Void approaches. And the powers latent within you are soon to awaken. The battle for Divinity has begun. Choose wisely and trust sparingly; darkness lurks within every heart.  Who will you be? A flesh-eating elf; an imperial lizard; an undead risen from the grave? Choose your race and origin story - or create your own! Discover how the world reacts differently to who - and what - you are.It’s time for a new Divinity!', 'https://media.rawg.io/media/games/424/424facd40f4eb1f2794fe4b4bb28a277.jpg', '2017-09-14', 'Strategy', 'GAME');
INSERT INTO Media VALUES(66, 'Stardew Valley', 'The hero (in the beginning you can choose gender, name and appearance) - an office worker who inherited an abandoned farm. The landscape of the farm can also be selected. For example, you can decide whether there will be a river nearby for fishing. The farm area needs to be cleared, and it will take time. The hero has many different activities: plant and care for plants, raise livestock, practice crafts, extract ore, and also enter into relationships with residents of the neighbouring town to earn game money. Relationships with characters include communication, performing tasks for money, exchanging, searching for fossils and even military actions and marrying. The character is limited by the reserve of strength and health - both parameters are visible on the screen, and the game automatically puts the hero to rest if the limit of his capabilities is close. The game does not set any ultimate or primary goal, its many possibilities are designed for an unlimited time.', 'https://media.rawg.io/media/games/713/713269608dc8f2f40f5a670a14b2de94.jpg', '2016-02-25', 'Indie', 'GAME');
INSERT INTO Media VALUES(67, 'Resident Evil 2', 'Resident Evil 2 is the remake of the 1998 game of the same name.   ###Plot', 'https://media.rawg.io/media/games/053/053fc543bf488349610f1ae2d0c1b51b.jpg', '2019-01-25', 'Shooter', 'GAME');
INSERT INTO Media VALUES(68, 'Sekiro: Shadows Die Twice', 'Sekiro: Shadows Die Twice is a game about a ninja (or shinobi, as they call it), who is seeking revenge in the Sengoku era Japan.  ###Plot', 'https://media.rawg.io/media/games/67f/67f62d1f062a6164f57575e0604ee9f6.jpg', '2019-03-22', 'Action', 'GAME');
INSERT INTO Media VALUES(69, 'Elden Ring', 'The Golden Order has been broken.  Rise, Tarnished, and be guided by grace to brandish the power of the Elden Ring and become an Elden Lord in the Lands Between.', 'https://media.rawg.io/media/games/b29/b294fdd866dcdb643e7bab370a552855.jpg', '2022-02-25', 'Action', 'GAME');
INSERT INTO Media VALUES(70, 'Cyberpunk 2077', 'Cyberpunk 2077 is a science fiction game loosely based on the role-playing game Cyberpunk 2020.  ###Setting', 'https://media.rawg.io/media/games/26d/26d4437715bee60138dab4a7c8c59c92.jpg', '2020-12-10', 'Shooter', 'GAME');
INSERT INTO Media VALUES(71, 'Batman: Arkham City', 'The plot of Arkham City begins one and a half years after the events of Arkham Asylum. Quincy Sharp, former superintendent of the Arkham Psychiatric Hospital, became mayor of Gotham and created the prison "Arkham City". Prisoners of Arkham City are not controlled by anyone in its borders, they are only forbidden from running away ... There are all the regular characters in the game - Joker, Two-Face, Catwoman, Ra''s al Ghul, James Gordon and others. Each villain individually and all of them together give Batman difficult tasks that move the game forward. Arkham City has an open world. All gadgets from Arkham Asylum are available to the player from the very beginning. Many of them are improved, there are also new ones. The game has a "Detective mode" - the skeletons of enemies are highlighted, it is possible to conduct various examinations, for example, tracking the flight of a sniper''s bullet. There is also access to a database that tracks villains in the city.', 'https://media.rawg.io/media/games/b5a/b5a1226bfd971284a735a4a0969086b3.jpg', '2011-10-18', 'Action', 'GAME');
INSERT INTO Media VALUES(72, 'The Big Bang Theory', 'Physicists Leonard and Sheldon find their nerd-centric social circle with pals Howard and Raj expanding when aspiring actress Penny moves in next door.', 'https://image.tmdb.org/t/p/original/ooBGRQBdbGzBxAVfExiO8r7kloA.jpg', '2007-09-24', 'Comedy', 'TV');
INSERT INTO Media VALUES(73, 'Mad Men', 'Set in 1960-1970 New York, this sexy, stylized and provocative drama follows the lives of the ruthlessly competitive men and women of Madison Avenue advertising.', 'https://image.tmdb.org/t/p/original/7v8iCNzKFpdlrCMcqCoJyn74Nsa.jpg', '2007-07-19', 'Drama', 'TV');
INSERT INTO Media VALUES(74, 'The Office', 'The everyday lives of office employees in the Scranton, Pennsylvania branch of the fictional Dunder Mifflin Paper Company.', 'https://image.tmdb.org/t/p/original/7DJKHzAi83BmQrWLrYYOqcoKfhR.jpg', '2005-03-24', 'Comedy', 'TV');
INSERT INTO Media VALUES(75, 'The Marvelous Mrs. Maisel', 'It’s 1958 Manhattan and Miriam “Midge” Maisel has everything she’s ever wanted - the perfect husband, kids, and Upper West Side apartment. But when her life suddenly takes a turn and Midge must start over, she discovers a previously unknown talent - one that will take her all the way from the comedy clubs of Greenwich Village to a spot on Johnny Carson’s couch.', 'https://image.tmdb.org/t/p/original/zS7fQiOZiKCVH2vlYSiIsFWW8hh.jpg', '2017-03-16', 'Comedy', 'TV');
INSERT INTO Media VALUES(76, 'Black Mirror', 'Over the last ten years, technology has transformed almost every aspect of our lives before we''ve had time to stop and question it. In every home; on every desk; in every palm - a plasma screen; a monitor; a smartphone - a black mirror of our 21st Century existence.', 'https://image.tmdb.org/t/p/original/5UaYsGZOFhjFDwQh6GuLjjA1WlF.jpg', '2011-12-04', 'Sci-Fi & Fantasy', 'TV');
INSERT INTO Media VALUES(77, 'Atlanta', 'Two cousins work through the Atlanta music scene in order to better their lives and the lives of their families.', 'https://image.tmdb.org/t/p/original/8HZyGMnPLVVb00rmrh6A2SbK9NX.jpg', '2016-09-06', 'Comedy', 'TV');
INSERT INTO Media VALUES(78, 'The Mandalorian', 'After the fall of the Galactic Empire, lawlessness has spread throughout the galaxy. A lone gunfighter makes his way through the outer reaches, earning his keep as a bounty hunter.', 'https://image.tmdb.org/t/p/original/eU1i6eHXlzMOlEq0ku1Rzq7Y4wA.jpg', '2019-11-12', 'Sci-Fi & Fantasy', 'TV');
INSERT INTO Media VALUES(79, 'Succession', 'Follow the lives of the Roy family as they contemplate their future once their aging father begins to step back from the media and entertainment conglomerate they control.', 'https://image.tmdb.org/t/p/original/7HW47XbkNQ5fiwQFYGWdw9gs144.jpg', '2018-06-03', 'Drama', 'TV');
INSERT INTO Media VALUES(80, 'BoJack Horseman', 'Meet the most beloved sitcom horse of the 90s - 20 years later. BoJack Horseman was the star of the hit TV show "Horsin'' Around," but today he''s washed up, living in Hollywood, complaining about everything, and wearing colorful sweaters.', 'https://image.tmdb.org/t/p/original/pB9L0jAnEQLMKgexqCEocEW8TA.jpg', '2014-08-22', 'Animation', 'TV');
INSERT INTO Media VALUES(81, 'The Good Place', 'Eleanor Shellstrop, an ordinary woman who, through an extraordinary string of events, enters the afterlife where she comes to realize that she hasn''t been a very good person. With the help of her wise afterlife mentor, she''s determined to shed her old way of living and discover the awesome (or at least the pretty good) person within.', 'https://image.tmdb.org/t/p/original/qIhsuhoIYR5yTnDta0IL4senbeN.jpg', '2016-09-19', 'Sci-Fi & Fantasy', 'TV');
INSERT INTO Media VALUES(82, 'Watchmen', 'Set in an alternate history where “superheroes” are treated as outlaws, “Watchmen” embraces the nostalgia of the original groundbreaking graphic novel while attempting to break new ground of its own.', 'https://image.tmdb.org/t/p/original/m8rWq3j73ZGhDuSCZWMMoE9ePH1.jpg', '2019-10-20', 'Drama', 'TV');
INSERT INTO Media VALUES(83, 'Narcos', 'A gritty chronicle of the war against Colombia''s infamously violent and powerful drug cartels.', 'https://image.tmdb.org/t/p/original/rTmal9fDbwh5F0waol2hq35U4ah.jpg', '2015-08-28', 'Crime', 'TV');
INSERT INTO Media VALUES(84, 'Ozark', 'A financial adviser drags his family from Chicago to the Missouri Ozarks, where he must launder $500 million in five years to appease a drug boss.', 'https://image.tmdb.org/t/p/original/pCGyPVrI9Fzw6rE1Pvi4BIXF6ET.jpg', '2017-07-21', 'Crime', 'TV');
INSERT INTO Media VALUES(85, 'Fleabag', 'A portrait into the mind of a dry-witted, sexual, angry, porn-watching, grief-riddled woman, trying to make sense of the world. As she hurls herself headlong at modern living, Fleabag is thrown roughly up against the walls of contemporary London, with all its frenetic energy, late nights, and bright lights.', 'https://image.tmdb.org/t/p/original/27vEYsRKa3eAniwmoccOoluEXQ1.jpg', '2016-07-21', 'Comedy', 'TV');
INSERT INTO Media VALUES(86, 'Yellowstone', 'Follow the violent world of the Dutton family, who controls the largest contiguous ranch in the United States. Led by their patriarch John Dutton, the family defends their property against constant attack by land developers, an Indian reservation, and America’s first National Park.', 'https://image.tmdb.org/t/p/original/peNC0eyc3TQJa6x4TdKcBPNP4t0.jpg', '2018-06-20', 'Western', 'TV');
INSERT INTO Media VALUES(87, 'Schitt''s Creek', 'Formerly filthy rich video store magnate Johnny Rose, his soap star wife Moira, and their two kids, über-hipster son David and socialite daughter Alexis, suddenly find themselves broke and forced to live in Schitt''s Creek, a small depressing town they once bought as a joke.', 'https://image.tmdb.org/t/p/original/iRfSzrPS5VYWQv7KVSEg2BZZL6C.jpg', '2015-01-13', 'Comedy', 'TV');
INSERT INTO Media VALUES(88, 'Better Call Saul', 'Six years before Saul Goodman meets Walter White. We meet him when the man who will become Saul Goodman is known as Jimmy McGill, a small-time lawyer searching for his destiny, and, more immediately, hustling to make ends meet. Working alongside, and, often, against Jimmy, is “fixer” Mike Ehrmantraut. The series tracks Jimmy’s transformation into Saul Goodman, the man who puts “criminal” in “criminal lawyer".', 'https://image.tmdb.org/t/p/original/fC2HDm5t0kHl7mTm7jxMR31b7by.jpg', '2015-02-08', 'Crime', 'TV');
INSERT INTO Media VALUES(89, 'The Walking Dead', 'Sheriff''s deputy Rick Grimes awakens from a coma to find a post-apocalyptic world dominated by flesh-eating zombies. He sets out to find his family and encounters many other survivors along the way.', 'https://image.tmdb.org/t/p/original/n7PVu0hSz2sAsVekpOIoCnkWlbn.jpg', '2010-10-31', 'Action & Adventure', 'TV');
INSERT INTO Media VALUES(90, 'Chernobyl', 'The true story of one of the worst man-made catastrophes in history: the catastrophic nuclear accident at Chernobyl. A tale of the brave men and women who sacrificed to save Europe from unimaginable disaster.', 'https://image.tmdb.org/t/p/original/hlLXt2tOPT6RRnjiUmoxyG1LTFi.jpg', '2019-05-06', 'Drama', 'TV');
INSERT INTO Media VALUES(91, 'Ted Lasso', 'Ted Lasso, an American football coach, moves to England when he’s hired to manage a soccer team—despite having no experience. With cynical players and a doubtful town, will he get them to see the Ted Lasso Way?', 'https://image.tmdb.org/t/p/original/5fhZdwP1DVJ0FyVH6vrFdHwpXIn.jpg', '2020-08-14', 'Comedy', 'TV');
INSERT INTO Media VALUES(92, 'The Crown', 'The gripping, decades-spanning inside story of Her Majesty Queen Elizabeth II and the Prime Ministers who shaped Britain''s post-war destiny.   The Crown tells the inside story of two of the most famous addresses in the world – Buckingham Palace and 10 Downing Street – and the intrigues, love lives and machinations behind the great events that shaped the second half of the 20th century. Two houses, two courts, one Crown.', 'https://image.tmdb.org/t/p/original/1M876KPjulVwppEpldhdc8V4o68.jpg', '2016-11-04', 'Drama', 'TV');
INSERT INTO Media VALUES(93, 'Euphoria', 'A group of high school students navigate love and friendships in a world of drugs, sex, trauma, and social media.', 'https://image.tmdb.org/t/p/original/3Q0hd3heuWwDWpwcDkhQOA6TYWI.jpg', '2019-06-16', 'Drama', 'TV');
INSERT INTO Media VALUES(94, 'The Handmaid''s Tale', 'Set in a dystopian future, a woman is forced to live as a concubine under a fundamentalist theocratic dictatorship. A TV adaptation of Margaret Atwood''s novel.', 'https://image.tmdb.org/t/p/original/tFTJ3YbOor3BtabI96QehXxEBii.jpg', '2017-04-26', 'Drama', 'TV');
INSERT INTO Media VALUES(95, 'Breaking Bad', 'Walter White, a New Mexico chemistry teacher, is diagnosed with Stage III cancer and given a prognosis of only two years left to live. He becomes filled with a sense of fearlessness and an unrelenting desire to secure his family''s financial future at any cost as he enters the dangerous world of drugs and crime.', 'https://image.tmdb.org/t/p/original/ztkUQFLlC19CCMYHW9o1zWhJRNq.jpg', '2008-01-20', 'Drama', 'TV');
INSERT INTO Media VALUES(96, 'Game of Thrones', 'Seven noble families fight for control of the mythical land of Westeros. Friction between the houses leads to full-scale war. All while a very ancient evil awakens in the farthest north. Amidst the war, a neglected military order of misfits, the Night''s Watch, is all that stands between the realms of men and icy horrors beyond.', 'https://image.tmdb.org/t/p/original/1XS1oqL89opfnbLl8WnZY1O1uJx.jpg', '2011-04-17', 'Sci-Fi & Fantasy', 'TV');
INSERT INTO Media VALUES(97, 'Homeland', 'CIA officer Carrie Mathison is tops in her field despite being bipolar, which makes her volatile and unpredictable. With the help of her long-time mentor Saul Berenson, Carrie fearlessly risks everything, including her personal well-being and even sanity, at every turn.', 'https://image.tmdb.org/t/p/original/6GAvS2e6VIRsms9FpVt33PsCoEW.jpg', '2011-10-02', 'Drama', 'TV');
INSERT INTO Media VALUES(98, 'The Boys', 'A group of vigilantes known informally as “The Boys” set out to take down corrupt superheroes with no more than blue-collar grit and a willingness to fight dirty.', 'https://image.tmdb.org/t/p/original/2zmTngn1tYC1AvfnrFLhxeD82hz.jpg', '2019-07-25', 'Sci-Fi & Fantasy', 'TV');
INSERT INTO Media VALUES(99, 'True Detective', 'An American anthology police detective series utilizing multiple timelines in which investigations seem to unearth personal and professional secrets of those involved, both within or outside the law.', 'https://image.tmdb.org/t/p/original/cuV2O5ZyDLHSOWzg3nLVljp1ubw.jpg', '2014-01-12', 'Drama', 'TV');
INSERT INTO Media VALUES(100, 'Friends', 'Six young people from New York City, on their own and struggling to survive in the real world, find the companionship, comfort and support they get from each other to be the perfect antidote to the pressures of life.', 'https://image.tmdb.org/t/p/original/2koX1xLkpTQM4IZebYvKysFW1Nh.jpg', '1994-09-22', 'Comedy', 'TV');
INSERT INTO Media VALUES(101, 'The Witcher', 'Geralt of Rivia, a mutated monster-hunter for hire, journeys toward his destiny in a turbulent world where people often prove more wicked than beasts.', 'https://image.tmdb.org/t/p/original/cZ0d3rtvXPVvuiX22sP79K3Hmjz.jpg', '2019-12-20', 'Sci-Fi & Fantasy', 'TV');
INSERT INTO Media VALUES(102, 'Downton Abbey', 'A chronicle of the lives of the aristocratic Crawley family and their servants in the post-Edwardian era—with great events in history having an effect on their lives and on the British social hierarchy. ', 'https://image.tmdb.org/t/p/original/7HgDYRYjym4BwbhKaqTQq771SKb.jpg', '2010-09-26', 'Drama', 'TV');
INSERT INTO Media VALUES(103, 'Stranger Things', 'When a young boy vanishes, a small town uncovers a mystery involving secret experiments, terrifying supernatural forces, and one strange little girl.', 'https://image.tmdb.org/t/p/original/49WJfeN0moxb9IPfGn8AIqMGskD.jpg', '2016-07-15', 'Drama', 'TV');
INSERT INTO Media VALUES(104, 'House of Cards', 'Set in present day Washington, D.C., House of Cards is the story of Frank Underwood, a ruthless and cunning politician, and his wife Claire who will stop at nothing to conquer everything. This wicked political drama penetrates the shadowy world of greed, sex and corruption in modern D.C.', 'https://image.tmdb.org/t/p/original/hKWxWjFwnMvkWQawbhvC0Y7ygQ8.jpg', '2013-02-01', 'Drama', 'TV');
INSERT INTO Media VALUES(105, 'Westworld', 'A dark odyssey about the dawn of artificial consciousness and the evolution of sin. Set at the intersection of the near future and the reimagined past, it explores a world in which every human appetite, no matter how noble or depraved, can be indulged.', 'https://image.tmdb.org/t/p/original/8MfgyFHf7XEboZJPZXCIDqqiz6e.jpg', '2016-10-02', 'Sci-Fi & Fantasy', 'TV');
INSERT INTO Media VALUES(106, 'The Sopranos', 'The story of New Jersey-based Italian-American mobster Tony Soprano and the difficulties he faces as he tries to balance the conflicting requirements of his home life and the criminal organization he heads. Those difficulties are often highlighted through his ongoing professional relationship with psychiatrist Jennifer Melfi. The show features Tony''s family members and Mafia associates in prominent roles and story arcs, most notably his wife Carmela and his cousin and protégé Christopher Moltisanti.', 'https://image.tmdb.org/t/p/original/57okJJUBK0AaijxLh3RjNUaMvFI.jpg', '1999-01-10', 'Drama', 'TV');
INSERT INTO Media VALUES(107, 'Daisy Jones & The Six', 'Daisy is a girl coming of age in L.A. in the late sixties, sneaking into clubs on the Sunset Strip, sleeping with rock stars, and dreaming of singing at the Whisky a Go Go. The sex and drugs are thrilling, but itÕs the rock ÕnÕ roll she loves most. By the time sheÕs twenty, her voice is getting noticed, and she has the kind of heedless beauty that makes people do crazy things.', 'http://books.google.com/books/content?id=zZJfDwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', '2019-03-05', 'Fiction', 'BOOK');
INSERT INTO Media VALUES(108, 'Becoming', 'In a life filled with meaning and accomplishment, Michelle Obama has emerged as one of the most iconic and compelling women of our era. As First Lady of the United States of AmericaÑthe first African American to serve in that roleÑshe helped create the most welcoming and inclusive White House in history, while also establishing herself as a powerful advocate for women and girls in the U.S. and around the world, dramatically changing the ways that families pursue healthier and more active lives, and standing with her husband as he led America through some of its most harrowing moments. Along the way, she showed us a few dance moves, crushed Carpool Karaoke, and raised two down-to-earth daughters under an unforgiving media glare.', 'http://books.google.com/books/content?id=V-8kEAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', '2021-03-02', 'Biography & Autobiography', 'BOOK');
INSERT INTO Media VALUES(109, 'The Song of Achilles', 'Achilles, "the best of all the Greeks," son of the cruel sea goddess Thetis and the legendary king Peleus, is strong, swift, and beautiful, irresistible to all who meet him. Patroclus is an awkward young prince, exiled from his homeland after an act of shocking violence. Brought together by chance, they forge an inseparable bond, despite risking the gods'' wrath.', 'http://books.google.com/books/content?id=szMU9omwV0wC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', '2012-04-12', 'Fiction', 'BOOK');
INSERT INTO Media VALUES(110, 'A Man Called Ove', 'A grumpy yet loveable man finds his solitary world turned on its head when a boisterous young family moves in next door.', 'http://books.google.com/books/content?id=b2CZEAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', '2022-11-29', 'Fiction', 'BOOK');
INSERT INTO Media VALUES(111, 'The Immortal Life of Henrietta Lacks', 'Her name was Henrietta Lacks, but scientists know her as HeLa. She was a poor Southern tobacco farmer who worked the same land as her enslaved ancestors, yet her cellsÑtaken without her knowledgeÑbecame one of the most important tools in medicine. The first ÒimmortalÓ human cells grown in culture, they are still alive today, though she has been dead for more than sixty years. If you could pile all HeLa cells ever grown onto a scale, theyÕd weigh more than 50 million metric tonsÑas much as a hundred Empire State Buildings. HeLa cells were vital for developing the polio vaccine; uncovered secrets of cancer, viruses, and the atom bombÕs effects; helped lead to important advances like in vitro fertilization, cloning, and gene mapping; and have been bought and sold by the billions.', 'http://books.google.com/books/content?id=GFevO-QxQDgC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', '2010-02-02', 'Science', 'BOOK');
INSERT INTO Media VALUES(112, 'The Shadow of the Wind', 'Barcelona, 1945: A city slowly heals from its war wounds, and Daniel, an antiquarian book dealer''s son who mourns the loss of his mother, finds solace in a mysterious book entitled The Shadow of the Wind, by one Julian Carax. But when he sets out to find the author''s other works, he makes a shocking discovery: someone has been systematically destroying every copy of every book Carax has written. In fact, Daniel may have the last of Carax''s books in existence. Soon Daniel''s seemingly innocent quest opens a door into one of Barcelona''s darkest secrets--an epic story of murder, madness, and doomed love.', 'http://books.google.com/books/content?id=ggvVsFqeCqYC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', '2005-01-25', 'Fiction', 'BOOK');
INSERT INTO Media VALUES(113, 'Where the Crawdads Sing', 'For years, rumors of the ÒMarsh GirlÓ haunted Barkley Cove, a quiet fishing village. Kya Clark is barefoot and wild; unfit for polite society. So in late 1969, when the popular Chase Andrews is found dead, locals immediately suspect her.', 'http://books.google.com/books/content?id=neUlEAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', '2021-03-30', 'Fiction', 'BOOK');
INSERT INTO Media VALUES(114, 'Gone Girl', 'Who are you? What have we done to each other? These are the questions Nick Dunne finds himself asking on the morning of his fifth wedding anniversary when his wife Amy suddenly disappears. The police suspect Nick. Amy''s friends reveal that she was afraid of him, that she kept secrets from him. He swears it isn''t true. A police examination of his computer shows strange searches. He says they weren''t made by him. And then there are the persistent calls on his mobile phone.', 'http://books.google.com/books/content?id=L25K1tY5WyoC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', '2012-06-05', 'Fiction', 'BOOK');
INSERT INTO Media VALUES(115, 'American Dirt (Oprah''s Book Club)', 'Jeanine Cummins''s American Dirt, the #1 New York Times bestseller and Oprah Book Club pick that has sold over two million copies, is finally available in paperback.Lydia lives in Acapulco. She has a son, Luca, the love of her life, and a wonderful husband who is a journalist. And while cracks are beginning to show in Acapulco because of the cartels, LydiaÕs life is, by and large, fairly comfortable. But after her husbandÕs tell-all profile of the newest drug lord is published, none of their lives will ever be the same.Forced to flee, Lydia and Luca find themselves joining the countless people trying to reach the United States. Lydia soon sees that everyone is running from something. But what exactly are they running to?', 'http://books.google.com/books/content?id=HfxJEAAAQBAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', '2020-01-21', 'Fiction', 'BOOK');
INSERT INTO Media VALUES(116, 'Before We Were Strangers', 'We met fifteen years ago, almost to the day, when I moved my stuff into the NYU dorm room next to yours at Senior House. You called us fast friends. I like to think it was more. We lived on nothing but the excitement of finding ourselves through music (you were obsessed with Jeff Buckley), photography (I couldnÕt stop taking pictures of you), hanging out in Washington Square Park, and all the weird things we did to make money. I learned more about myself that year than any other.', 'http://books.google.com/books/content?id=P5ivBAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', '2015-08-18', 'Fiction', 'BOOK');
INSERT INTO Media VALUES(117, 'Harry Potter and the Deathly Hallows', 'Give me Harry Potter,'' said Voldemort''s voice, ''and none shall be harmed. Give me Harry Potter, and I shall leave the school untouched. Give me Harry Potter, and you will be rewarded.'' As he climbs into the sidecar of Hagrid''s motorbike and takes to the skies, leaving Privet Drive for the last time, Harry Potter knows that Lord Voldemort and the Death Eaters are not far behind. The protective charm that has kept Harry safe until now is broken, but he cannot keep hiding. The Dark Lord is breathing fear into everything Harry loves and to stop him Harry will have to find and destroy the remaining Horcruxes. The final battle must begin - Harry must stand and face his enemy... Having become classics of our time, the Harry Potter eBooks never fail to bring comfort and escapism. With their message of hope, belonging and the enduring power of truth and love, the story of the Boy Who Lived continues to delight generations of new readers.', 'http://books.google.com/books/content?id=_oaAHiFOZmgC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', '2015-12-08', 'Juvenile Fiction', 'BOOK');
INSERT INTO Media VALUES(118, 'The Silent Patient', 'Alicia BerensonÕs life is seemingly perfect. A famous painter married to an in-demand fashion photographer, she lives in a grand house with big windows overlooking a park in one of LondonÕs most desirable areas. One evening her husband Gabriel returns home late from a fashion shoot, and Alicia shoots him five times in the face, and then never speaks another word.', 'http://books.google.com/books/content?id=tLdiDwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', '2019-02-05', 'Fiction', 'BOOK');
INSERT INTO Media VALUES(119, 'Normal People', 'At school Connell and Marianne pretend not to know each other. HeÕs popular and well-adjusted, star of the school soccer team while she is lonely, proud, and intensely private. But when Connell comes to pick his mother up from her housekeeping job at MarianneÕs house, a strange and indelible connection grows between the two teenagers - one they are determined to conceal.', 'http://books.google.com/books/content?id=kwBlDwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', '2019-04-16', 'Fiction', 'BOOK');
INSERT INTO Media VALUES(120, 'The Da Vinci Code (Republish)', 'While in Paris on business, Harvard symbologist Robert Langdon receives an urgent late-night phone call: the elderly curator of the Louvre has been murdered inside the museum. Near the body, police have found a baffling cipher. While working to solve the enigmatic riddle, Langdon is stunned to discover it leads to a trail of clues hidden in the works of Da Vinci -- clues visible for all to see -- yet ingeniously disguised by the painter.', 'http://books.google.com/books/content?id=6-pmDwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', '2018-08-02', 'Fiction', 'BOOK');
INSERT INTO Media VALUES(121, 'Big Little Lies', 'Madeline is a force to be reckoned with. SheÕs funny, biting, and passionate; she remembers everything and forgives no one. Celeste is the kind of beautiful woman who makes the world stop and stare but she is paying a price for the illusion of perfection. New to town, single mom Jane is so young that another mother mistakes her for a nanny. She comes with a mysterious past and a sadness beyond her years. These three women are at different crossroads, but they will all wind up in the same shocking place.', 'http://books.google.com/books/content?id=QNQBDAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', '2015-08-11', 'Fiction', 'BOOK');
INSERT INTO Media VALUES(122, 'Grey', 'Christian Grey exercises control in all things; his world is neat, disciplined, and utterly emptyÑuntil the day that Anastasia Steele falls into his office, in a tangle of shapely limbs and tumbling brown hair. He tries to forget her, but instead is swept up in a storm of emotion he cannot comprehend and cannot resist. Unlike any woman he has known before, shy, unworldly Ana seems to see right through himÑpast the business prodigy and the penthouse lifestyle to ChristianÕs cold, wounded heart.  ', 'http://books.google.com/books/content?id=YHiNEAAAQBAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', '2015-06-30', 'Fiction', 'BOOK');
INSERT INTO Media VALUES(123, 'Educated', 'Tara Westover was 17 the first time she set foot in a classroom. Born to survivalists in the mountains of Idaho, she prepared for the end of the world by stockpiling home-canned peaches and sleeping with her "head-for-the-hills bag". In the summer she stewed herbs for her mother, a midwife and healer, and in the winter she salvaged in her father''s junkyard.', 'http://books.google.com/books/content?id=2ObWDgAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', '2018-02-20', 'Biography & Autobiography', 'BOOK');
INSERT INTO Media VALUES(124, 'The Hunger Games', 'In the ruins of a place once known as North America lies the nation of Panem, a shining Capitol surrounded by twelve outlying districts. The Capitol is harsh and cruel and keeps the districts in line by forcing them all to send one boy and one girl between the ages of twelve and eighteen to participate in the annual Hunger Games, a fight to the death on live TV. Sixteen-year-old Katniss Everdeen, who lives alone with her mother and younger sister, regards it as a death sentence when she is forced to represent her district in the Games. But Katniss has been close to dead and survival, for her, is second nature. Without really meaning to, she becomes a contender. But if she is to win, she will have to start making choices that weigh survival against humanity and life against love.', 'http://books.google.com/books/content?id=Yz8Fnw0PlEQC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', '2009-09-01', 'Young Adult Fiction', 'BOOK');
INSERT INTO Media VALUES(125, 'A Thousand Splendid Suns', 'Mariam is only fifteen when she is sent to Kabul to marry the troubled and bitter Rasheed, who is thirty years her senior. Nearly two decades later, in a climate of growing unrest, tragedy strikes fifteen-year-old Laila, who must leave her home and join Mariam''s unhappy household. Laila and Mariam are to find consolation in each other, their friendship to grow as deep as the bond between sisters, as strong as the ties between mother and daughter.', 'http://books.google.com/books/content?id=3vo0NQbIN2YC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', '2008-09-18', 'Fiction', 'BOOK');
INSERT INTO Media VALUES(126, 'The Seven Husbands of Evelyn Hugo', 'The epic adventures Evelyn creates over the course of a lifetime will leave every reader mesmerized. This wildly addictive journey of a reclusive Hollywood starlet and her tumultuous Tinseltown journey comes with unexpected twists and the most satisfying of drama.', 'http://books.google.com/books/content?id=IdAmDwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', '2017-06-13', 'Fiction', 'BOOK');
INSERT INTO Media VALUES(127, 'The Girl with the Dragon Tattoo', 'Harriet Vanger, a scion of one of SwedenÕs wealthiest families disappeared over forty years ago. All these years later, her aged uncle continues to seek the truth. He hires Mikael Blomkvist, a crusading journalist recently trapped by a libel conviction, to investigate. He is aided by the pierced and tattooed punk prodigy Lisbeth Salander. Together they tap into a vein of unfathomable iniquity and astonishing corruption.', 'http://books.google.com/books/content?id=WrL9de30FDMC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', '2008-09-16', 'Fiction', 'BOOK');
INSERT INTO Media VALUES(128, 'All the Light We Cannot See', 'Marie-Laure lives in Paris near the Museum of Natural History, where her father works. When she is twelve, the Nazis occupy Paris and father and daughter flee to the walled citadel of Saint-Malo, where Marie-LaureÕs reclusive great uncle lives in a tall house by the sea. With them they carry what might be the museumÕs most valuable and dangerous jewel.', 'http://books.google.com/books/content?id=0cH0AAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', '2014-05-06', 'Fiction', 'BOOK');
INSERT INTO Media VALUES(129, 'The Help', 'Twenty-two-year-old Skeeter has just returned home after graduating from Ole Miss. She may have a degree, but it is 1962, Mississippi, and her mother will not be happy till Skeeter has a ring on her finger. Skeeter would normally find solace with her beloved maid Constantine, the woman who raised her, but Constantine has disappeared and no one will tell Skeeter where she has gone.', 'http://books.google.com/books/content?id=aFACDAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', '2009-02-10', 'Fiction', 'BOOK');
INSERT INTO Media VALUES(130, 'The Light We Lost', 'Lucy and Gabe meet as seniors at Columbia University on a day that changes both of their lives forever. Together, they decide they want their lives to mean something, to matter. When they meet again a year later, it seems fatedÑperhaps theyÕll find lifeÕs meaning in each other. But then Gabe becomes a photojournalist assigned to the Middle East and Lucy pursues a career in New York. What follows is a thirteen-year journey of dreams, desires, jealousies, betrayals, and, ultimately, of love. Was it fate that brought them together? Is it choice that has kept them away? Their journey takes Lucy and Gabe continents apart, but never out of each otherÕs hearts.', 'http://books.google.com/books/content?id=B54RDQAAQBAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', '2017-05-09', 'Fiction', 'BOOK');
INSERT INTO Media VALUES(131, 'The Goldfinch', 'A young New Yorker grieving his mother''s death is pulled into a gritty underworld of art and wealth in this "extraordinary" and beloved Pulitzer Prize winner from the author of The Secret History that "connects with the heart as well as the mind" (Stephen King, New York Times Book Review). Theo Decker, a 13-year-old New Yorker, miraculously survives an accident that kills his mother. Abandoned by his father, Theo is taken in by the family of a wealthy friend. Bewildered by his strange new home on Park Avenue, disturbed by schoolmates who don''t know how to talk to him, and tormented above all by a longing for his mother, he clings to the one thing that reminds him of her: a small, mysteriously captivating painting that ultimately draws Theo into a wealthy and insular art community. As an adult, Theo moves silkily between the drawing rooms of the rich and the dusty labyrinth of an antiques store where he works. He is alienated and in love â and at the center of a narrowing, ever more dangerous circle. The Goldfinch is a mesmerizing, stay-up-all-night and tell-all-your-friends triumph, an old-fashioned story of loss and obsession, survival and self-invention. From the streets of New York to the dark corners of the art underworld, this "soaring masterpiece" examines the devastating impact of grief and the ruthless machinations of fate (Ron Charles, Washington Post).', 'http://books.google.com/books/content?id=dvuK7isszLIC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', '2013-10-22', 'Fiction', 'BOOK');
INSERT INTO Media VALUES(132, 'Sapiens', 'From a renowned historian comes a groundbreaking narrative of humanityÕs creation and evolutionÑa #1 international bestsellerÑthat explores the ways in which biology and history have defined us and enhanced our understanding of what it means to be Òhuman.Ó One hundred thousand years ago, at least six different species of humans inhabited Earth. Yet today there is only oneÑhomo sapiens. What happened to the others? And what may happen to us?', 'http://books.google.com/books/content?id=FmyBAwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', '2015-02-10', 'Science', 'BOOK');
INSERT INTO Media VALUES(133, 'Circe', 'In the house of Helios, god of the sun and mightiest of the Titans, a daughter is born. But Circe is a strange child--neither powerful like her father nor viciously alluring like her mother. Turning to the world of mortals for companionship, she discovers that she does possess power: the power of witchcraft, which can transform rivals into monsters and menace the gods themselves.', 'http://books.google.com/books/content?id=GrGdDwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', '2019-04-22', 'Juvenile Fiction', 'BOOK');
INSERT INTO Media VALUES(134, 'The Road', 'A father and his son walk alone through burned America. Nothing moves in the ravaged landscape save the ash on the wind. It is cold enough to crack stones, and when the snow falls it is gray. The sky is dark. Their destination is the coast, although they donÕt know what, if anything, awaits them there. They have nothing; just a pistol to defend themselves against the lawless bands that stalk the road, the clothes they are wearing, a cart of scavenged foodÑand each other.', 'http://books.google.com/books/content?id=PfmjWho_zOAC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', '2007-03-20', 'Fiction', 'BOOK');
INSERT INTO Media VALUES(135, 'The Kite Runner', 'Afghanistan, 1975: Twelve-year-old Amir is desperate to win the local kite-fighting tournament and his loyal friend Hassan promises to help him. But neither of the boys can foresee what will happen to Hassan that afternoon, an event that is to shatter their lives. After the Russians invade and the family is forced to flee to America, Amir realises that one day he must return to Afghanistan under Taliban rule to find the one thing that his new world cannot grant him: redemption.', 'http://books.google.com/books/content?id=MH48bnzN0LUC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', '2011-09-05', 'Fiction', 'BOOK');
INSERT INTO Media VALUES(136, 'The Book Thief', 'By her brother''s graveside, Liesel''s life is changed when she picks up a single object, partially hidden in the snow. It is The Gravedigger''s Handbook, left behind there by accident, and it is her first act of book thievery. So begins a love affair with books and words, as Liesel, with the help of her accordian-playing foster father, learns to read. Soon she is stealing books from Nazi book-burnings, the mayor''s wife''s library, wherever there are books to be found.', 'http://books.google.com/books/content?id=veGXULZK6UAC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', '2007-12-18', 'Young Adult Fiction', 'BOOK');
INSERT INTO Media VALUES(137, 'The Fault in Our Stars', 'Despite the tumor-shrinking medical miracle that has bought her a few years, Hazel has never been anything but terminal, her final chapter inscribed upon diagnosis. But when a gorgeous plot twist named Augustus Waters suddenly appears at Cancer Kid Support Group, Hazel''s story is about to be completely rewritten.', 'http://books.google.com/books/content?id=UzqVUdEtLDwC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', '2012-01-10', 'Young Adult Fiction', 'BOOK');
INSERT INTO Media VALUES(138, 'The Night Circus', 'Waging a fierce competition for which they have trained since childhood, circus magicians Celia and Marco unexpectedly fall in love with each other and share a fantastical romance that manifests in fateful ways.', 'http://books.google.com/books/content?id=l530VTtXVDwC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', '2011-09-13', 'Fiction', 'BOOK');
INSERT INTO Media VALUES(139, 'The Twilight Saga Complete Collection', 'This stunning set, complete with five editions of Twilight, New Moon, Eclipse, Breaking Dawn, and The Short Second Life of Bree Tanner: An Eclipse Novella, makes the perfect gift for fans of the bestselling vampire love story. Deeply romantic and extraordinarily suspenseful, The Twilight Saga capture the struggle between defying our instincts and satisfying our desires', 'http://books.google.com/books/content?id=GfMSW5w3NTwC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', '2010-11-08', 'Young Adult Fiction', 'BOOK');
INSERT INTO Media VALUES(140, 'Little Fires Everywhere', 'Everyone in Shaker Heights was talking about it that summer: how Isabelle, the last of the Richardson children, had finally gone around the bend and burned the house down.', 'http://books.google.com/books/content?id=OsUPDgAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', '2017-09-12', 'Fiction', 'BOOK');
INSERT INTO Media VALUES(141, 'Blinding Lights', 'Blinding Lights is a song by Canadian singer The Weeknd from his fourth studio album, After Hours (2020).', 'https://ia802905.us.archive.org/13/items/mbid-c400ecc6-74a5-47ba-a96a-0f0cdf454642/mbid-c400ecc6-74a5-47ba-a96a-0f0cdf454642-26139758068_thumb250.jpg', '2019-11-29', 'Synthwave', 'MUSIC');
INSERT INTO Media VALUES(142, 'Shape of You', 'Shape of You is a song by English singer-songwriter Ed Sheeran from his third studio album, ÷ (2017).', 'https://ia801900.us.archive.org/6/items/mbid-1308acf9-a4af-4f1e-ab8c-341509262809/mbid-1308acf9-a4af-4f1e-ab8c-341509262809-15618217317.jpg', '2017-01-06', 'Pop', 'MUSIC');
INSERT INTO Media VALUES(143, 'Uptown Funk', 'Uptown Funk is a song by British record producer Mark Ronson featuring American singer Bruno Mars.', 'https://coverartarchive.org/release-group/bce20d09-d903-4370-8047-0f589a5258c2/front', '2014-11-10', 'Funk', 'MUSIC');
INSERT INTO Media VALUES(144, 'Rolling in the Deep', 'Rolling in the Deep is a song recorded by English singer-songwriter Adele for her second studio album, 21 (2011).', 'https://coverartarchive.org/release-group/b5801cd8-c309-48fa-a449-02167a047a17/front', '2010-11-30', 'Soul', 'MUSIC');
INSERT INTO Media VALUES(145, 'Happy', 'Happy is a song written, produced, and performed by American singer Pharrell Williams.', 'https://coverartarchive.org/release/c3307585-ec2a-4e9e-884d-8fa3a04de3d9/7110127859.jpg', '2014-1-24', 'Pop', 'MUSIC');
INSERT INTO Media VALUES(146, 'Old Town Road', 'Old Town Road is a song by American rapper Lil Nas X, first released independently in 2018.', 'https://coverartarchive.org/release-group/663278dd-e331-4b48-be09-e98782730d5c/front', '2018-12-03', 'Country Rap', 'MUSIC');
INSERT INTO Media VALUES(147, 'Drivers License', 'Drivers License is the debut single by American singer-songwriter Olivia Rodrigo.', 'https://coverartarchive.org/release/2f147a4b-7a77-4f5e-a1f3-346f54c5879a/28255629579.jpg', '2021-01-08', 'Pop', 'MUSIC');
INSERT INTO Media VALUES(148, 'Despacito', 'Despacito is a song by Puerto Rican singer Luis Fonsi featuring Puerto Rican rapper Daddy Yankee.', 'https://coverartarchive.org/release/27a6a251-8ee7-4bb2-9f25-c2c3afe46503/16448831336.jpg', '2017-01-13', 'Reggaeton', 'MUSIC');
INSERT INTO Media VALUES(149, 'Bad Guy', 'Bad Guy is a song by American singer Billie Eilish, released on March 29, 2019.', 'https://coverartarchive.org/release-group/a101e74c-a54f-4b90-bec7-d8e3b4d627c9/front', '2019-03-29', 'Electropop', 'MUSIC');
INSERT INTO Media VALUES(150, 'Rockstar', 'Rockstar is a song by American rapper Post Malone featuring 21 Savage.', 'https://coverartarchive.org/release/67c1f3b9-ebcb-4134-9555-c614861aedc4/18015340224.jpg', '2017-09-15', 'Hip Hop', 'MUSIC');
INSERT INTO Media VALUES(151, 'Levitating', 'Levitating is a song by English singer Dua Lipa from her second studio album, Future Nostalgia (2020).', 'https://coverartarchive.org/release/cbfcb90c-6a08-40cc-aaa9-0da740ac2aff/36995041720.jpg', '2020-3-27', 'Disco-pop', 'MUSIC');
INSERT INTO Media VALUES(152, 'Shake It Off', 'Shake It Off is a song recorded by American singer-songwriter Taylor Swift.', 'https://coverartarchive.org/release-group/999e9130-0fc3-4667-8455-f283d7f7fabf/front', '2014-08-18', 'Pop', 'MUSIC');
INSERT INTO Media VALUES(153, 'Hello', 'Hello is a song by English singer Adele, released as the lead single from her third studio album, 25 (2015).', 'https://coverartarchive.org/release/535340e4-cb7e-43ae-a6fa-e68550c77682/26149285999.jpg', '2015-10-23', 'Soul', 'MUSIC');
INSERT INTO Media VALUES(154, 'All of Me', 'All of Me is a song by American singer John Legend from his fourth studio album, Love in the Future (2013).', 'https://coverartarchive.org/release/904480fb-2957-47a3-bce9-361782497765/35674716066.jpg', '2013-08-08', 'R&B', 'MUSIC');
INSERT INTO Media VALUES(155, 'Stay', 'Stay is a song by The Kid LAROI and Justin Bieber.', 'https://coverartarchive.org/release/9edb549d-b9cd-47b8-8b33-523b0bf8e301/29843695490.jpg', '2021-07-09', 'Pop', 'MUSIC');
INSERT INTO Media VALUES(156, 'Can’t Stop the Feeling!', 'Can’t Stop the Feeling! is a song recorded by American singer Justin Timberlake.', 'https://coverartarchive.org/release/40c5abcc-a290-47ca-97c7-cb727469e99f/32417858241.jpg', '2016-05-06', 'Disco-pop', 'MUSIC');
INSERT INTO Media VALUES(157, 'Sunflower', 'Sunflower is a song performed by American rappers and singers Post Malone and Swae Lee.', 'https://coverartarchive.org/release/60066d49-3ca6-40da-9235-97508e3f7fc7/21243439920.jpg', '2018-10-18', 'Hip Hop', 'MUSIC');
INSERT INTO Media VALUES(158, 'Havana', 'Havana is a song recorded by Cuban-American singer Camila Cabello featuring guest vocals from American rapper Young Thug.', 'https://coverartarchive.org/release/d8593cc6-4573-4f5f-81f7-f6ce5c0bd711/17427809507.jpg', '2017-08-03', 'Latin Pop', 'MUSIC');
INSERT INTO Media VALUES(159, 'Senorita', 'Señorita is a song by Canadian singer Shawn Mendes and Cuban-American singer Camila Cabello.', 'https://coverartarchive.org/release/b0caac0c-6b71-41ec-b76d-a6f81692b2dc/23360088062.jpg', '2019-06-21', 'Latin Pop', 'MUSIC');
INSERT INTO Media VALUES(160, 'Sorry', 'Sorry is a song recorded by Canadian singer Justin Bieber for his fourth studio album, Purpose (2015).', 'https://coverartarchive.org/release/6818723a-ba44-4e7d-aed8-cfeafc450e3a/12656705747.png', '2015-10-22', 'Pop', 'MUSIC');
INSERT INTO Media VALUES(161, 'Roar', 'Roar is a song by American singer Katy Perry for her fourth studio album, Prism (2013).', 'https://coverartarchive.org/release/571feff4-76c9-49e8-8fb9-04cf265c433c/4914393030.jpg', '2013-09-08', 'Pop', 'MUSIC');
INSERT INTO Media VALUES(162, 'Someone Like You', 'Someone Like You is a song by English singer-songwriter Adele, released on her second studio album, 21 (2011).', 'https://coverartarchive.org/release-group/6f37b6d7-fb39-4657-beb6-462c7c953cf7/front', '2011-01-24', 'Pop', 'MUSIC');
INSERT INTO Media VALUES(163, 'Lucid Dreams', 'Lucid Dreams is a song by American rapper Juice WRLD.', 'https://coverartarchive.org/release/b3df094d-1317-4c4a-8dd1-0eadeeaf7b58/38164814242.jpg', '2018-05-04', 'Hip Hop', 'MUSIC');
INSERT INTO Media VALUES(164, 'Shallow', 'Shallow is a song by Lady Gaga and Bradley Cooper from the soundtrack of the 2018 film A Star Is Born.', 'https://coverartarchive.org/release/fe5944f9-293a-46b1-b7e2-73df7df989d1/21126051060.jpg', '2018-09-27', 'Soundtrack', 'MUSIC');
INSERT INTO Media VALUES(165, 'See You Again', 'See You Again is a song by American rapper Wiz Khalifa, featuring American singer Charlie Puth.', 'https://coverartarchive.org/release/59563f7c-2913-4517-8c63-6d1da3ab5557/10172895562.jpg', '2015-03-17', 'Hip Hop', 'MUSIC');
INSERT INTO Media VALUES(166, 'Radioactive', 'Radioactive is a song by American rock band Imagine Dragons.', 'https://coverartarchive.org/release/56967928-6654-41e3-97c2-ad211c4b5745/22742548824.jpg', '2012-10-29', 'Rock', 'MUSIC');
INSERT INTO Media VALUES(167, 'Closer', 'Closer is a song by American DJ duo The Chainsmokers featuring American singer Halsey.', 'https://coverartarchive.org/release/1eb06cd0-1c8f-4535-b7d7-115c8d44eb01/14222480270.jpg', '2016-07-29', 'EDM', 'MUSIC');
INSERT INTO Media VALUES(168, 'One Dance', 'One Dance is a song by Canadian rapper Drake from his fourth studio album, Views (2016).', 'https://coverartarchive.org/release/e2f55bbb-a03a-4f83-8122-a536406a1e69/13330683772.jpg', '2016-04-05', 'Afrobeats', 'MUSIC');
INSERT INTO Media VALUES(169, 'We Found Love', 'We Found Love is a song recorded by Barbadian singer Rihanna from her sixth studio album, Talk That Talk (2011).', 'https://coverartarchive.org/release/33a4f03b-610a-45f3-af82-03750f4b3494/39195237934.jpg', '2011-09-22', 'Dance-pop', 'MUSIC');
INSERT INTO Media VALUES(170, 'Call Me Maybe', 'Call Me Maybe is a song recorded by Canadian singer Carly Rae Jepsen for her EP Curiosity (2012).', 'https://image.url/call_me_maybe.jpg', '2011-09-20', 'Pop', 'MUSIC');
INSERT INTO Media VALUES(171, 'Stay With Me', 'Stay with Me is a song by English singer Sam Smith from their debut studio album, In the Lonely Hour (2014).', 'https://coverartarchive.org/release/75893ee3-4019-40a1-99af-06a9586b91a5/8796946876.png', '2014-06-02', 'Soul', 'MUSIC');
INSERT INTO Media VALUES(172, 'Royals', 'Royals is a song by New Zealand singer Lorde.', 'https://coverartarchive.org/release/0eff78b4-1014-4f74-bc5f-604b37ed0f4a/9829111208.jpg', '2013-06-03', 'Indie pop', 'MUSIC');
INSERT INTO Media VALUES(173, 'WAP', 'WAP is a song recorded by American rappers Cardi B and Megan Thee Stallion.', 'https://coverartarchive.org/release-group/49deb866-e5b1-400d-8464-45ab63191ed6/front', '2020-08-07', 'Hip Hop', 'MUSIC');
INSERT INTO Media VALUES(174, 'DNA.', ' Kendrick Lamar''s hard-hitting track that blends sharp lyricism with a bold, minimalist beat, delivering a message about self-awareness, humility, and societal pressures, becoming one of his most iconic and commercially successful songs.', 'https://coverartarchive.org/release/7c59d15d-ef1a-48f6-9af6-51a1add92780/16465758904.jpg', '2017-04-14', 'Hip-Hop', 'MUSIC');
INSERT INTO Media VALUES(175, 'the 1', 'a reflective, indie-folk track by Taylor Swift that opens her folklore album, exploring themes of nostalgia and lost love with a mellow, introspective tone, becoming a fan favorite for its relatable lyrics and stripped-down production.', 'https://coverartarchive.org/release-group/f1d08326-c23b-4b43-be3b-20b33ab10bf6/front', '2020-07-24', 'Indie', 'MUSIC');

-- Insert Values into Movies Table
INSERT INTO Movies VALUES(0, 'en', 7.382, 'Trevante Rhodes', 'Black', 'André Holland', 'Kevin', 'Barry Jenkins');
INSERT INTO Movies VALUES(1, 'en', 8.154, 'Joaquin Phoenix', 'Arthur Fleck', 'Robert De Niro', 'Murray Franklin', 'Todd Phillips');
INSERT INTO Movies VALUES(2, 'en', 7.456, 'Fionn Whitehead', 'Tommy', 'Tom Hardy', 'Farrier', 'Christopher Nolan');
INSERT INTO Movies VALUES(3, 'en', 4.914, 'Robert Glaudini', 'Dr. Paul Dean', 'Demi Moore', 'Patricia Welles', 'Peter Manoogian');
INSERT INTO Movies VALUES(4, 'en', 7.857, 'Joaquin Phoenix', 'Theodore', 'Scarlett Johansson', 'Samantha (voice)', 'Thomas Patrick Smith');
INSERT INTO Movies VALUES(5, 'en', 7.245, 'Sally Hawkins', 'Elisa Esposito', 'Michael Shannon', 'Richard Strickland', 'Guillermo del Toro');
INSERT INTO Movies VALUES(6, 'en', 7.368, 'Jesse Eisenberg', 'Mark Zuckerberg', 'Andrew Garfield', 'Eduardo Saverin', 'David Fincher');
INSERT INTO Movies VALUES(7, 'en', 8.218, 'Russell Crowe', 'Maximus Meridius', 'Joaquin Phoenix', 'Emperor Commodus', 'Ridley Scott');
INSERT INTO Movies VALUES(8, 'en', 7.941, 'Chiwetel Ejiofor', 'Solomon Northup', 'Michael Fassbender', 'Edwin Epps', 'Steve McQueen');
INSERT INTO Movies VALUES(9, 'en', 8.482, 'Elijah Wood', 'Frodo', 'Ian McKellen', 'Gandalf', 'Peter Jackson');
INSERT INTO Movies VALUES(10, 'en', 7.533, 'Leonardo DiCaprio', 'Hugh Glass', 'Tom Hardy', 'John Fitzgerald', 'Alejandro González Iñárritu');
INSERT INTO Movies VALUES(11, 'en', 8.381, 'Miles Teller', 'Andrew', 'J.K. Simmons', 'Fletcher', 'Damien Chazelle');
INSERT INTO Movies VALUES(12, 'en', 7.622, 'Daniel Kaluuya', 'Chris Washington', 'Allison Williams', 'Rose Armitage', 'Rhona Rubio');
INSERT INTO Movies VALUES(13, 'en', 8.368, 'Leonardo DiCaprio', 'Dom Cobb', 'Joseph Gordon-Levitt', 'Arthur', 'Christopher Nolan');
INSERT INTO Movies VALUES(14, 'en', 7.784, 'Timothée Chalamet', 'Paul Atreides', 'Rebecca Ferguson', 'Lady Jessica Atreides', 'John Harrison');
INSERT INTO Movies VALUES(15, 'en', 3.167, 'None', 'None', 'None', 'None', 'Guy Bolongaro');
INSERT INTO Movies VALUES(16, 'en', 7.9, 'Ryan Gosling', 'Sebastian', 'Emma Stone', 'Mia', 'Damien Chazelle');
INSERT INTO Movies VALUES(17, 'en', 7.501, 'Lady Gaga', 'Ally Campana', 'Bradley Cooper', 'Jackson Maine', 'Lyn Matsuda Norton');
INSERT INTO Movies VALUES(18, 'en', 7.783, 'Michelle Yeoh', 'Evelyn Wang', 'Stephanie Hsu', 'Joy Wang / Jobu Tupaki', 'Jeff Desom');
INSERT INTO Movies VALUES(19, 'en', 7.607, 'Robert De Niro', 'Frank Sheeran', 'Al Pacino', 'Jimmy Hoffa', 'Francisco Ortiz');
INSERT INTO Movies VALUES(20, 'en', 8.204, 'Tom Cruise', 'Capt. Pete ''Maverick'' Mitchell', 'Miles Teller', 'Lt. Bradley ''Rooster'' Bradshaw', 'Tony Scott');
INSERT INTO Movies VALUES(21, 'en', 7.606, 'Amy Adams', 'Louise Banks', 'Jeremy Renner', 'Ian Donnelly', 'Denis Villeneuve');
INSERT INTO Movies VALUES(22, 'en', 7.384, 'Chadwick Boseman', 'T''Challa / Black Panther', 'Michael B. Jordan', 'Erik Killmonger', 'Riley Flanagan');
INSERT INTO Movies VALUES(23, 'en', 8.251, 'Robert Downey Jr.', 'Tony Stark / Iron Man', 'Chris Evans', 'Steve Rogers / Captain America', 'Paul Schneider');
INSERT INTO Movies VALUES(24, 'en', 7.567, 'Ryan Gosling', '''K''', 'Harrison Ford', 'Rick Deckard', 'Bud Yorkin');
INSERT INTO Movies VALUES(25, 'en', 7.641, 'Amy Poehler', 'Joy (voice)', 'Maya Hawke', 'Anxiety (voice)', 'Kelsey Mann');
INSERT INTO Movies VALUES(26, 'en', 7.945, 'Javier Bardem', 'Anton Chigurh', 'Tommy Lee Jones', 'Ed Tom Bell', 'Joel Coen');
INSERT INTO Movies VALUES(27, 'en', 8.516, 'Christian Bale', 'Bruce Wayne / Batman', 'Heath Ledger', 'Joker', 'Christopher Nolan');
INSERT INTO Movies VALUES(28, 'en', 8.023, 'Roman Griffin Davis', 'Jojo', 'Thomasin McKenzie', 'Elsa', 'Taika Waititi');
INSERT INTO Movies VALUES(29, 'en', 7.6, 'Tom Hardy', 'Max Rockatansky', 'Charlize Theron', 'Imperator Furiosa', 'George Miller');
INSERT INTO Movies VALUES(30, 'en', 7.582, 'Sam Worthington', 'Jake Sully', 'Zoe Saldaña', 'Neytiri', 'James Cameron');
INSERT INTO Movies VALUES(31, 'en', 8.049, 'Ralph Fiennes', 'M. Gustave', 'F. Murray Abraham', 'Mr. Moustafa', 'Wes Anderson');
INSERT INTO Movies VALUES(32, 'en', 8.035, 'Leonardo DiCaprio', 'Jordan Belfort', 'Jonah Hill', 'Donnie Azoff', 'Martin Scorsese');
INSERT INTO Movies VALUES(33, 'en', 8.4, 'Shameik Moore', 'Miles Morales (voice)', 'Jake Johnson', 'Peter B. Parker (voice)', 'Kyle Fukuto');
INSERT INTO Movies VALUES(34, 'en', 8.441, 'Matthew McConaughey', 'Cooper', 'Anne Hathaway', 'Brand', 'Christopher Nolan');

-- Insert Values into Games Table
INSERT INTO Games VALUES(35, 'Sony Interactive Entertainment', 'PC', 83.0, 'Mature');
INSERT INTO Games VALUES(36, 'Electronic Arts', 'PC', 95.0, 'Everyone 10+');
INSERT INTO Games VALUES(37, 'Sony Interactive Entertainment', 'PC', 94.0, 'Mature');
INSERT INTO Games VALUES(38, 'Nintendo', 'Nintendo Switch', 97.0, 'Everyone 10+');
INSERT INTO Games VALUES(39, 'Microsoft Studios', 'PC', 91.0, 'Mature');
INSERT INTO Games VALUES(40, 'Microsoft Studios', 'PC', 83.0, 'Everyone 10+');
INSERT INTO Games VALUES(41, 'Activision Blizzard', 'PC', 80.0, 'Not Rated');
INSERT INTO Games VALUES(42, 'Bethesda Softworks', 'PC', 94.0, 'Mature');
INSERT INTO Games VALUES(43, 'Innersloth', 'PC', 82.0, 'Everyone 10+');
INSERT INTO Games VALUES(44, '8-4', 'PC', 92.0, 'Everyone 10+');
INSERT INTO Games VALUES(45, 'Rockstar Games', 'PC', 92.0, 'Mature');
INSERT INTO Games VALUES(46, 'Epic Games Publishing', 'PC', 0, 'Teen');
INSERT INTO Games VALUES(47, 'Rockstar Games', 'PC', 96.0, 'Mature');
INSERT INTO Games VALUES(48, 'Sony Computer Entertainment', 'PlayStation 4', 92.0, 'Mature');
INSERT INTO Games VALUES(49, 'Matt Makes Games', 'PC', 91.0, 'Everyone 10+');
INSERT INTO Games VALUES(50, 'Sony Computer Entertainment', 'PlayStation 4', 95.0, 'Mature');
INSERT INTO Games VALUES(51, 'Capcom', 'PC', 89.0, 'Teen');
INSERT INTO Games VALUES(52, 'Supergiant Games', 'PC', 93.0, 'Teen');
INSERT INTO Games VALUES(53, 'Team Cherry', 'PC', 88.0, 'Everyone 10+');
INSERT INTO Games VALUES(54, 'Deep Silver', 'PlayStation 4', 93.0, 'Mature');
INSERT INTO Games VALUES(55, 'Psyonix', 'PC', 86.0, 'Everyone');
INSERT INTO Games VALUES(56, '505 Games', 'PC', 81.0, 'Teen');
INSERT INTO Games VALUES(57, 'Bandai Namco Entertainment', 'PC', 0, 'Mature');
INSERT INTO Games VALUES(58, 'Electronic Arts', 'PC', 94.0, 'Mature');
INSERT INTO Games VALUES(59, 'Activision Blizzard', 'PC', 91.0, 'Teen');
INSERT INTO Games VALUES(60, 'Nintendo', 'Nintendo Switch', 97.0, 'Everyone 10+');
INSERT INTO Games VALUES(61, 'Bandai Namco Entertainment', 'PC', 89.0, 'Mature');
INSERT INTO Games VALUES(62, 'Nintendo', 'Nintendo Switch', 90.0, 'Everyone');
INSERT INTO Games VALUES(63, 'CD PROJEKT RED', 'PC', 92.0, 'Mature');
INSERT INTO Games VALUES(64, 'Sony Computer Entertainment', 'PlayStation 5', 93.0, 'Teen');
INSERT INTO Games VALUES(65, 'Larian Studios', 'PC', 95.0, 'Mature');
INSERT INTO Games VALUES(66, 'Chucklefish', 'PC', 89.0, 'Everyone 10+');
INSERT INTO Games VALUES(67, 'Capcom', 'PC', 91.0, 'Mature');
INSERT INTO Games VALUES(68, 'Activison', 'PC', 90.0, 'Mature');
INSERT INTO Games VALUES(69, 'Bandai Namco Entertainment', 'PC', 95.0, 'Mature');
INSERT INTO Games VALUES(70, 'CD PROJEKT RED', 'PC', 73.0, 'Mature');
INSERT INTO Games VALUES(71, 'Warner Bros. Interactive', 'PC', 94.0, 'Teen');

-- Insert Values into Tv Table
INSERT INTO Tv VALUES(72, 'en', 7.9, 279, 12, 'Ended', 'CBS');
INSERT INTO Tv VALUES(73, 'en', 8.122, 92, 7, 'Ended', 'AMC');
INSERT INTO Tv VALUES(74, 'en', 8.575, 186, 9, 'Ended', 'NBC');
INSERT INTO Tv VALUES(75, 'en', 8.08, 43, 5, 'Ended', 'Prime Video');
INSERT INTO Tv VALUES(76, 'en', 8.285, 32, 7, 'Returning Series', 'Channel 4');
INSERT INTO Tv VALUES(77, 'en', 8.028, 41, 4, 'Ended', 'FX');
INSERT INTO Tv VALUES(78, 'en', 8.4, 24, 3, 'Returning Series', 'Disney+');
INSERT INTO Tv VALUES(79, 'en', 8.264, 39, 4, 'Ended', 'HBO');
INSERT INTO Tv VALUES(80, 'en', 8.558, 76, 6, 'Ended', 'Netflix');
INSERT INTO Tv VALUES(81, 'en', 7.968, 50, 4, 'Ended', 'NBC');
INSERT INTO Tv VALUES(82, 'en', 7.675, 9, 1, 'Ended', 'HBO');
INSERT INTO Tv VALUES(83, 'en', 8.03, 30, 3, 'Ended', 'Netflix');
INSERT INTO Tv VALUES(84, 'en', 8.211, 44, 4, 'Ended', 'Netflix');
INSERT INTO Tv VALUES(85, 'en', 8.289, 12, 2, 'Ended', 'BBC Three');
INSERT INTO Tv VALUES(86, 'en', 8.197, 53, 5, 'Returning Series', 'Paramount Network');
INSERT INTO Tv VALUES(87, 'en', 7.705, 79, 6, 'Ended', 'CBC Television');
INSERT INTO Tv VALUES(88, 'en', 8.687, 63, 6, 'Ended', 'AMC');
INSERT INTO Tv VALUES(89, 'en', 8.113, 177, 11, 'Ended', 'AMC');
INSERT INTO Tv VALUES(90, 'en', 8.678, 5, 1, 'Ended', 'HBO');
INSERT INTO Tv VALUES(91, 'en', 8.443, 34, 3, 'Returning Series', 'Apple TV+');
INSERT INTO Tv VALUES(92, 'en', 8.211, 60, 6, 'Ended', 'Netflix');
INSERT INTO Tv VALUES(93, 'en', 8.313, 16, 2, 'Returning Series', 'HBO');
INSERT INTO Tv VALUES(94, 'en', 8.179, 56, 6, 'Returning Series', 'Hulu');
INSERT INTO Tv VALUES(95, 'en', 8.916, 62, 5, 'Ended', 'AMC');
INSERT INTO Tv VALUES(96, 'en', 8.455, 73, 8, 'Ended', 'HBO');
INSERT INTO Tv VALUES(97, 'en', 7.548, 96, 8, 'Ended', 'Showtime');
INSERT INTO Tv VALUES(98, 'en', 8.475, 32, 5, 'Returning Series', 'Prime Video');
INSERT INTO Tv VALUES(99, 'en', 8.296, 30, 4, 'Returning Series', 'HBO');
INSERT INTO Tv VALUES(100, 'en', 8.438, 228, 10, 'Ended', 'NBC');
INSERT INTO Tv VALUES(101, 'en', 8.06, 24, 4, 'Returning Series', 'Netflix');
INSERT INTO Tv VALUES(102, 'en', 8.105, 47, 6, 'Ended', 'ITV1');
INSERT INTO Tv VALUES(103, 'en', 8.602, 42, 5, 'Returning Series', 'Netflix');
INSERT INTO Tv VALUES(104, 'en', 8.022, 73, 6, 'Ended', 'Netflix');
INSERT INTO Tv VALUES(105, 'en', 8.047, 36, 4, 'Canceled', 'HBO');
INSERT INTO Tv VALUES(106, 'en', 8.643, 86, 6, 'Ended', 'HBO');

-- Insert Values into Books Table
INSERT INTO Books VALUES(107, 'Ballantine Books', 'Taylor Jenkins Reid', 'NOT_MATURE', 393, 9781524798635);
INSERT INTO Books VALUES(108, 'Crown', 'Michelle Obama', 'NOT_MATURE', 482, 9781524763145);
INSERT INTO Books VALUES(109, 'A&C Black', 'Madeline Miller', 'NOT_MATURE', 370, 9781408826133);
INSERT INTO Books VALUES(110, 'Simon and Schuster', 'Fredrik Backman', 'NOT_MATURE', 368, 9781668010815);
INSERT INTO Books VALUES(111, 'Crown', 'Rebecca Skloot', 'NOT_MATURE', 386, 9780307589385);
INSERT INTO Books VALUES(112, 'Penguin', 'Carlos Ruiz Zafon', 'NOT_MATURE', 512, 9781101147061);
INSERT INTO Books VALUES(113, 'Penguin', 'Delia Owens', 'NOT_MATURE', 401, 9780735219106);
INSERT INTO Books VALUES(114, 'Ballantine Books', 'Gillian Flynn', 'NOT_MATURE', 497, 9780307588388);
INSERT INTO Books VALUES(115, 'Holt Paperbacks', 'Jeanine Cummins', 'NOT_MATURE', 496, 9781250209788);
INSERT INTO Books VALUES(116, 'Simon and Schuster', 'Renee Carlino', 'NOT_MATURE', 320, 9781501105784);
INSERT INTO Books VALUES(117, 'Pottermore Publishing', 'J.K. Rowling', 'NOT_MATURE', 769, 9781781102435);
INSERT INTO Books VALUES(118, 'Celadon Books', 'Alex Michaelides', 'NOT_MATURE', 322, 9781250301710);
INSERT INTO Books VALUES(119, 'Crown', 'Sally Rooney', 'NOT_MATURE', 305, 9781984822192);
INSERT INTO Books VALUES(120, 'Bentang Pustaka', 'Dan Brown', 'NOT_MATURE', 681, 9786022911845);
INSERT INTO Books VALUES(121, 'Penguin', 'Liane Moriarty', 'NOT_MATURE', 513, 9780425274866);
INSERT INTO Books VALUES(122, 'National Geographic Books', 'E L James', 'NOT_MATURE', 576, 9780399565335);
INSERT INTO Books VALUES(123, 'Random House', 'Tara Westover', 'NOT_MATURE', 352, 9780399590511);
INSERT INTO Books VALUES(124, 'Scholastic Inc.', 'Suzanne Collins', 'NOT_MATURE', 387, 9780545229937);
INSERT INTO Books VALUES(125, 'A&C Black', 'Khaled Hosseini', 'NOT_MATURE', 380, 9780747585893);
INSERT INTO Books VALUES(126, 'Simon and Schuster', 'Taylor Jenkins Reid', 'NOT_MATURE', 400, 9781501139239);
INSERT INTO Books VALUES(127, 'Vintage Crime/Black Lizard', 'Stieg Larsson', 'NOT_MATURE', 480, 9780307272119);
INSERT INTO Books VALUES(128, 'Simon and Schuster', 'Anthony Doerr', 'NOT_MATURE', 560, 9781476746609);
INSERT INTO Books VALUES(129, 'Penguin', 'Kathryn Stockett', 'NOT_MATURE', 546, 9780425245132);
INSERT INTO Books VALUES(130, 'HarperCollins UK', 'Jill Santopolo', 'NOT_MATURE', 230, 9780008224585);
INSERT INTO Books VALUES(131, 'Little, Brown', 'Donna Tartt', 'NOT_MATURE', 780, 9780316248679);
INSERT INTO Books VALUES(132, 'Harper Collins', 'Yuval Noah Harari', 'NOT_MATURE', 403, 9780062316103);
INSERT INTO Books VALUES(133, 'Gramedia pustaka utama', 'Madeline Miller', 'NOT_MATURE', 546, 9786020628950);
INSERT INTO Books VALUES(134, 'Vintage', 'Cormac McCarthy', 'NOT_MATURE', 257, 9780307267450);
INSERT INTO Books VALUES(135, 'A&C Black', 'Khaled Hosseini', 'NOT_MATURE', 337, 9781408824856);
INSERT INTO Books VALUES(136, 'Knopf Books for Young Readers', 'Markus Zusak', 'NOT_MATURE', 578, 9780307433848);
INSERT INTO Books VALUES(137, 'Penguin', 'John Green', 'NOT_MATURE', 336, 9781101569184);
INSERT INTO Books VALUES(138, 'Doubleday', 'Erin Morgenstern', 'NOT_MATURE', 401, 9780385534635);
INSERT INTO Books VALUES(139, 'Little, Brown Books for Young Readers', 'Stephenie Meyer', 'NOT_MATURE', 2336, 9780316182935);
INSERT INTO Books VALUES(140, 'Penguin', 'Celeste Ng', 'NOT_MATURE', 354, 9780735224308);

-- Insert Values into Music Table
INSERT INTO Music VALUES(141, 'The Weeknd', 203, 'Oscar Holter','XO');
INSERT INTO Music VALUES(142, 'Ed Sheeran', 234, 'Joe Rubel', 'Atlantic');
INSERT INTO Music VALUES(143, 'Bruno Mars', 235, 'Mark Ronson', 'Columbia');
INSERT INTO Music VALUES(144, 'Adele', 228, 'Paul Epworth', 'Columbia');
INSERT INTO Music VALUES(145, 'Pharrell Williams', 469, 'Pharrell Williams', 'Columbia');
INSERT INTO Music VALUES(146, 'Lil Nas X', 113, 'Atticus Matthew Ross', 'Columbia');
INSERT INTO Music VALUES(147, 'Olivia Rodrigo', 242, 'Daniel Nigro', 'Olivia Rodrigo PS');
INSERT INTO Music VALUES(148, 'Luis Fonsi', 457, 'Mauricio Rengifo', 'Universal Music Latino');
INSERT INTO Music VALUES(149, 'Billie Eilish', 194, 'FINNEAS', 'Interscope Records');
INSERT INTO Music VALUES(150, 'Post Malone', 218, 'Louis Bell', 'Republic Records');
INSERT INTO Music VALUES(151, 'Dua Lipa', 204, 'Stephen Kozmeniuk', 'Warner Records');
INSERT INTO Music VALUES(152, 'Taylor Swift', 219, 'Max Martin', 'Big Machine Records');
INSERT INTO Music VALUES(153, 'Adele', 295, 'Greg Kurstin', 'Columbia');
INSERT INTO Music VALUES(154, 'John Legend', 270, 'Dave Tozer', 'Columbia');
INSERT INTO Music VALUES(155, 'Kid Laroi', 142, 'Charlie Puth', 'Columbia');
INSERT INTO Music VALUES(156, 'Justin Timberlake', 236, 'Max Martin', 'RCA');
INSERT INTO Music VALUES(157, 'Post Malone', 158, 'Louis Bell', 'Universal Records');
INSERT INTO Music VALUES(158, 'Camila Cabello', 217, 'Matt Beckley', 'Epic');
INSERT INTO Music VALUES(159, 'Camila Cabello', 191, 'Benn Blanco', 'Island');
INSERT INTO Music VALUES(160, 'Justin Bieber', 200, 'BLOOD', 'Def Jam Recordings');
INSERT INTO Music VALUES(161, 'Katy Perry', 222, 'Cirkut', 'Capitol Records');
INSERT INTO Music VALUES(162, 'Adele', 285, 'Dan Wilson', 'XL Recordings');
INSERT INTO Music VALUES(163, 'Juice WRLD', 239, 'Nick Mira', 'Grade A Productions');
INSERT INTO Music VALUES(164, 'Lady Gaga', 245, 'Benjamin Rice', 'Interscope Records');
INSERT INTO Music VALUES(165, 'Wiz Khalifa', 230, 'Mike Caren', 'Atlantic');
INSERT INTO Music VALUES(166, 'Imagine Dragons', 187, 'Alex da Kid', 'KidinaKorner');
INSERT INTO Music VALUES(167, 'The Chainsmokers', 244, 'DJ Swivel', 'Columbia');
INSERT INTO Music VALUES(168, 'Drake', 173, 'Nineteen85', 'Cash Money Records');
INSERT INTO Music VALUES(169, 'Rihanna', 215, 'Kuk Harrell', 'The Island Def Jam Music Group');
INSERT INTO Music VALUES(170, 'Carly Rae Jepson', 194, 'Josh Ramsay', 'Interscope Records');
INSERT INTO Music VALUES(171, 'Sam Smith', 173, 'Jimmy Napes', 'Capitol Records');
INSERT INTO Music VALUES(172, 'Lorde', 190, 'Joel Little', 'Republic Records');
INSERT INTO Music VALUES(173, 'Cardi B', 188, 'Ayo the Producer', 'Atlantic');
INSERT INTO Music VALUES(174, 'Kendrick Lamar', 186, 'Mike Will Made It', 'Aftermath Entertainment');
INSERT INTO Music VALUES(175, 'Taylor Swift', 210, 'Aaron Dessner', 'Republic');

-- Insert Mock media items into various collections
INSERT INTO [Collection_contains_Media] (collectionId, mediaId, dateAdded) VALUES
(1, 1, '2024-01-31'),
(1, 36, '2024-02-01'),
(2, 2, '2024-02-02'),
(2, 38, '2024-02-03'),
(3, 73, '2024-02-04'),
(3, 74, '2024-02-05'),
(4, 108, '2024-02-06'),
(4, 111, '2024-02-07'),
(5, 142, '2024-02-08'),
(5, 143, '2024-02-09'),
(6, 11, '2024-02-10'),
(6, 39, '2024-02-11'),
(7, 46, '2024-02-12'),
(7, 47, '2024-02-13'),
(8, 86, '2024-02-14'),
(8, 88, '2024-02-15'),
(9, 112, '2024-02-16'),
(9, 113, '2024-02-17'),
(10, 151, '2024-02-18'),
(10, 153, '2024-02-19'),
(11, 6, '2024-02-20'),
(11, 8, '2024-02-21'),
(12, 37, '2024-02-22'),
(12, 55, '2024-02-23'),
(13, 91, '2024-02-24'),
(13, 93, '2024-02-25'),
(14, 116, '2024-02-26'),
(14, 118, '2024-02-27'),
(15, 161, '2024-02-28'),
(15, 162, '2024-02-29'),
(16, 13, '2024-03-01'),
(16, 14, '2024-03-02'),
(17, 48, '2024-03-03'),
(17, 49, '2024-03-04'),
(18, 96, '2024-03-05'),
(18, 98, '2024-03-06'),
(19, 121, '2024-03-07'),
(19, 122, '2024-03-08'),
(20, 146, '2024-03-09'),
(20, 148, '2024-03-10'),
(21, 19, '2024-03-11'),
(21, 20, '2024-03-12'),
(22, 61, '2024-03-13'),
(22, 62, '2024-03-14'),
(23, 77, '2024-03-15'),
(23, 78, '2024-03-16'),
(24, 127, '2024-03-17'),
(24, 128, '2024-03-18'),
(25, 157, '2024-03-19'),
(25, 159, '2024-03-20'),
(26, 26, '2024-03-21'),
(26, 28, '2024-03-22'),
(27, 66, '2024-03-23'),
(27, 68, '2024-03-24'),
(28, 81, '2024-03-25'),
(28, 83, '2024-03-26'),
(29, 132, '2024-03-27'),
(29, 134, '2024-03-28'),
(30, 171, '2024-03-29'),
(30, 173, '2024-03-30');

-- Insert Mock Review Data
INSERT INTO Review (rating, reviewTitle, reviewText) VALUES
(5, 'Breathtaking Visuals', 'The movie had stunning visuals and a captivating storyline.'),
(4, 'Solid Action Movie', 'Great action sequences but slightly predictable plot.'),
(3, 'Fun Game', 'A fun game with a few repetitive mechanics but overall enjoyable.'),
(2, 'Unbalanced Gameplay', 'The gameplay was fun, but certain levels were overly difficult.'),
(1, 'Disappointing Game', 'Had high expectations, but the game felt rushed and unpolished.'),
(4, 'Engaging TV Drama', 'The characters were well-developed, and the plot twists kept me hooked.'),
(5, 'Must-Watch Series', 'One of the best TV shows I’ve ever seen. Emotional and gripping.'),
(2, 'Slow Book', 'The story dragged on, and it took a while to get to the main plot.'),
(1, 'Dull and Boring', 'I struggled to finish reading this book.'),
(3, 'Average Novel', 'It had its moments, but the writing felt a bit lacking.'),
(4, 'Great Sci-Fi Movie', 'Loved the concept and the special effects were top-notch.'),
(5, 'Masterpiece', 'This movie is a classic. It redefined the genre.'),
(3, 'Good Adventure Game', 'The story was engaging, but some mechanics were clunky.'),
(4, 'Challenging Game', 'A tough but rewarding experience with excellent graphics.'),
(5, 'Immersive RPG', 'Incredible world-building and storyline, a must-play.'),
(2, 'Overhyped Show', 'Not bad, but I don’t understand the hype.'),
(1, 'Terrible Show', 'I couldn’t finish the series. It was just too slow.'),
(4, 'Solid Book', 'A compelling read with a few pacing issues.'),
(3, 'Decent Fantasy Novel', 'Good world-building, but the characters lacked depth.'),
(5, 'Masterful Writing', 'A beautifully written book with deep themes and complex characters.'),
(4, 'Catchy Album', 'Most of the tracks were great, with a few standouts.'),
(3, 'Mixed Bag', 'Some songs were amazing, but others fell flat.'),
(2, 'Forgettable Album', 'Nothing about this album stood out to me.'),
(5, 'Perfect Playlist', 'Every track was a hit. Loved it!'),
(1, 'Not My Taste', 'I couldn’t connect with any of the songs.'),
(4, 'Top-notch TV Show', 'Great storyline with superb acting.'),
(3, 'Average Show', 'It had its moments but struggled with pacing.'),
(5, 'Incredible Series', 'From start to finish, it kept me hooked.'),
(4, 'Fun Read', 'A light and enjoyable book that’s perfect for a lazy weekend.'),
(2, 'Not Worth the Hype', 'The book didn’t live up to my expectations.'),
(1, 'Worst Movie Ever', 'Bad acting, weak plot. Total waste of time.'),
(5, 'Amazing Soundtrack', 'Every track resonated with me. A beautiful album.'),
(3, 'Decent Mystery Book', 'The plot twists were predictable, but it was still a fun read.'),
(4, 'Solid Game', 'Gameplay and graphics were impressive, but the story was lacking.'),
(5, 'Great Rock Album', 'Loved every track, a true classic.'),
(4, 'Unexpectedly Good Show', 'This TV show turned out to be a pleasant surprise.'),
(3, 'Decent Series', 'Not the best, but worth a watch if you’re into the genre.'),
(5, 'Amazing Finale', 'The last book in the series was a perfect conclusion.'),
(4, 'Engaging Storyline', 'This book had a captivating story that kept me hooked.'),
(5, 'A Musical Masterpiece', 'One of the best albums I’ve listened to this year.');

INSERT INTO Review_for (reviewId, userId, mediaId, reviewedAt) VALUES
(1, 1, 2, '2024-02-01'),
(2, 2, 10, '2024-02-02'),
(3, 3, 37, '2024-02-03'),
(4, 4, 55, '2024-02-04'),
(5, 5, 45, '2024-02-05'),
(6, 6, 75, '2024-02-06'),
(7, 7, 85, '2024-02-07'),
(8, 8, 109, '2024-02-08'),
(9, 9, 115, '2024-02-09'),
(10, 10, 143, '2024-02-10'),
(11, 11, 0, '2024-02-11'),
(12, 12, 20, '2024-02-12'),
(13, 13, 53, '2024-02-13'),
(14, 14, 50, '2024-02-14'),
(15, 15, 82, '2024-02-15'),
(16, 16, 95, '2024-02-16'),
(17, 17, 107, '2024-02-17'),
(18, 18, 125, '2024-02-18'),
(19, 19, 155, '2024-02-19'),
(20, 20, 170, '2024-02-20'),
(21, 21, 5, '2024-02-21'),
(22, 22, 30, '2024-02-22'),
(23, 23, 40, '2024-02-23'),
(24, 24, 60, '2024-02-24'),
(25, 25, 90, '2024-02-25'),
(26, 26, 100, '2024-02-26'),
(27, 27, 110, '2024-02-27'),
(28, 28, 120, '2024-02-28'),
(29, 29, 145, '2024-02-29'),
(30, 30, 160, '2024-03-01'),
(31, 1, 15, '2024-03-02'),
(32, 2, 22, '2024-03-03'),
(33, 3, 53, '2024-03-04'),
(34, 4, 65, '2024-03-05'),
(35, 5, 82, '2024-03-06'),
(36, 6, 101, '2024-03-07'),
(37, 7, 112, '2024-03-08'),
(38, 8, 128, '2024-03-09'),
(39, 9, 148, '2024-03-10'),
(40, 10, 172, '2024-03-11');

-- Write 10 Descriptive Aggregate, Joins, Subqueries

-- 1) Display the genre and titles of all the media contained in collection with id 25 [JOIN 1]
SELECT m.name AS title, m.genre
FROM Collection_contains_Media ccm
JOIN Media m ON ccm.mediaId = m.mediaId
WHERE ccm.collectionId = 25;

-- 2) Find the average rating of media that has been reviewed by a user [Join 2]
SELECT m.mediaId, m.[name] AS mediaName, AVG(r.rating) AS averageRating
FROM Media m
JOIN Review_for rf ON m.mediaId = rf.mediaId
JOIN Review r ON rf.reviewId = r.reviewId
GROUP BY m.mediaId, m.[name]
ORDER BY averageRating DESC;

-- 3) Find the number of collections that have been created by each user [Aggregate 1]
SELECT email, COUNT(collectionId) AS num_collections 
FROM (
    [user] LEFT JOIN User_Creates_Collection 
    ON([user].id = User_Creates_Collection.userId)
) GROUP BY email;

-- 4) Find the most common media genre among all the media titles [Aggregate 2]
SELECT TOP 1 genre
FROM Media 
GROUP BY genre 
ORDER BY COUNT(mediaId) DESC;

-- 5) Find all the songs that have a duration of at least 250 seconds [Subquery 1]
SELECT [name] AS song_name FROM Media WHERE mediaId IN (
    SELECT mediaId FROM Music WHERE songDuration >= 250
);

-- 6) Find the lead actor for all movies that came out after 2010 [Subquery 2]
SELECT [name], 
    (
        SELECT leadActor FROM Movies 
        WHERE Media.mediaId = Movies.mediaId
    ) AS lead_actor 
FROM Media 
WHERE release_date >= CONVERT(datetime, '2010-01-01') 
AND Media.[type] = 'MOVIE';

-- 7) Find the min and max rating of the reviews each user has posted
SELECT 
    U.id, firstName, lastName,
    MIN(rating) AS min_rating,
    MAX(rating) AS max_rating
FROM Review R
LEFT JOIN Review_for RF
ON R.reviewId = RF.reviewId
LEFT JOIN [user] U
ON RF.userId = U.id
GROUP BY U.id, firstName, lastName;

-- 8) Select all the media titles that have been added to a collection with the tag 'health'
SELECT mediaId, [name] FROM Media WHERE mediaId IN (
    SELECT DISTINCT mediaId FROM Collection_tags CT
    JOIN Collection_contains_Media CCM
    ON CT.collectionId = CCM.collectionId
    WHERE tag = 'health'
);

-- 9) For all the books that have been reveiwed by users, find the average rating
SELECT [name], AVG(rating) AS avg_rating FROM Media M
RIGHT JOIN Review_for RF
ON M.mediaId = RF.mediaId
LEFT JOIN Review R
ON RF.reviewId = R.reviewId
WHERE M.mediaId IN (
    SELECT mediaId FROM Books
)
GROUP BY M.mediaId, M.name;

-- 10) For each TV network, find the TV show that has the most episodes and the number of episodes
WITH MaxEpisodes AS (
    SELECT network, MAX(numberOfEpisodes) AS max_episodes
    FROM Tv
    GROUP BY network
) SELECT ME.network, [name], max_episodes FROM MaxEpisodes ME
JOIN Tv T ON ME.network = T.network AND ME.max_episodes = T.numberOfEpisodes
JOIN Media M ON T.mediaId = M.mediaId;

-- Drop All Tables
-- DROP TABLE Review_for;
-- DROP TABLE Review;
-- DROP TABLE Collection_tags;
-- DROP TABLE Collection_contains_Media;
-- DROP TABLE User_Creates_Collection;
-- DROP TABLE [Collection];
-- DROP TABLE Movies;
-- DROP TABLE Games;
-- DROP TABLE Tv;
-- DROP TABLE Music;
-- DROP TABLE Books;
-- DROP TABLE Media;
-- DROP TABLE [user];

-- Select All data
-- SELECT * FROM Books;
-- SELECT * FROM [Collection];
-- SELECT * FROM Collection_contains_Media;
-- SELECT * FROM [Collection_tags];
-- SELECT * FROM Games;
-- SELECT * FROM Media;
-- SELECT * FROM Movies;
-- SELECT * FROM Music;
-- SELECT * FROM Review;
-- SELECT * FROM Review_for;
-- SELECT * FROM Tv;
-- SELECT * FROM [user];
-- SELECT * FROM [User_Creates_Collection];
