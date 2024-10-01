import React, {useEffect, useContext, useState, createContext} from "react";

const AuthContext = createContext();

export function useAuth() {
    return useContext(AuthContext);
}

export function AuthProvider(props) {
    const [authUser, setAuthUser] = useState(null);
    const [isLoggedIn, setIsLoggedIn] = useState(false);

    const value = {
        authUser,
        setAuthUser,
        isLoggedIn,
        setIsLoggedIn
    }

    // Children enclosed with Auth Provider have access to properties with value object
    return(
        <AuthContext.Provider value={value}>
            {props.children}
        </AuthContext.Provider>
    );
}