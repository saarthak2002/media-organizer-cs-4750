const { queryDatabase } = require("../db");

const findUserByEmail = async (email) => {
    try {
        const userWithEmail = await queryDatabase(`SELECT * FROM dbo.[user] WHERE email = '${email}';`)
        return userWithEmail;
    }
    catch(err) {
        console.log(err);
        return null;
    }
}

const createUser = async (email, password, firstName, lastName) => {
    try {
        const newUser = await queryDatabase(`INSERT INTO [user] (email, passwordHash, firstName, lastName) VALUES ('${email}', '${password}', '${firstName}', '${lastName}')`);
        return newUser;
    }
    catch(err) {
        console.log(err);
        return null;
    }
}

module.exports = {
    findUserByEmail,
    createUser
}