import React, {useEffect, useState} from "react";
import { useAuth } from "../contexts/AuthContext";
import Signup from "./Signup";

const Dashboard = () => {

    const {authUser, setAuthUser, isLoggedIn, setIsLoggedIn} = useAuth();

    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [showSignUpForm, setShowSignUpForm] = useState(false);
    const [showAlert, setShowAlert] = useState(false);
    const [alertText, setAlertText] = useState('');
    const [showNewUserBanner, setShowNewUserBanner] = useState(false);

    useEffect(() => {
        const user = localStorage.getItem('MEDIA_ORGANIZER_USER');
        if(user) {
            setAuthUser(JSON.parse(user));
            setIsLoggedIn(true);
        }
    }, [setAuthUser, setIsLoggedIn]);

    const logIn = async (event) => {
        event.preventDefault();
        
        setShowAlert(false);
        setAlertText('');
        setShowNewUserBanner(false);

        if(email === "" || password === "") {
            setAlertText("Enter a valid email and password.");
            setShowAlert(true);
            setEmail("");
            setPassword("");
            return;
        }

        try {
            const response = await fetch(`${process.env.REACT_APP_API_BASE}/login`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(
                    {
                        email: email,
                        password: password
                    }
                )
            })

            if(response.status === 200) {
                const jsonResponse = await response.json();
                setIsLoggedIn(true);
                setAuthUser(jsonResponse);
                localStorage.setItem('MEDIA_ORGANIZER_USER', JSON.stringify(jsonResponse));
            }
            else {
                if(response.status === 401) {
                    console.log("incorrect password");
                    setAlertText("The password you have entered is incorrect.")
                }
                else if (response.status === 404) {
                    console.log('A user with this email does not exist')
                    setAlertText("A user with this email does not exist.")
                } else {
                    console.log('There was an error logging you in, please try later')
                    setAlertText("There was an error logging you in, please try later.")
                }

                setShowAlert(true);
                setIsLoggedIn(false);
                setAuthUser(null);
                localStorage.removeItem("MEDIA_ORGANIZER_USER");
                setPassword("");
            }
        }
        catch(err) {
            console.log(err);
            setIsLoggedIn(false);
            setAuthUser(null);
            localStorage.removeItem("MEDIA_ORGANIZER_USER");
            setAlertText("There was an error logging you in, please try later.")
            setShowAlert(true);
            setPassword("");
        }
    }

    const logOut = (event) => {
        event.preventDefault();
        setIsLoggedIn(false);
        setAuthUser(null);
        localStorage.removeItem("MEDIA_ORGANIZER_USER");
        setEmail("");
        setPassword("");
    }

    return(
        <>

            <span>User is currently: {isLoggedIn ? "Logged in" : "Logged out"}</span>
            {
                isLoggedIn ?
                    (
                        <div>
                            <span>User email: {authUser.email}</span>
                            <br />
                            <span>{authUser.firstName} {authUser.lastName}</span>
                        </div>
                    ) : (
                        <div>

                        </div>
                    )
            }

            <br></br>

            {
                isLoggedIn ? (
                    <button onClick={(event) => logOut(event)}>
                        Log out
                    </button>
                ) : (
                    <>
                        {
                        showSignUpForm ? 
                        (
                            <Signup setShowSignUpForm={setShowSignUpForm} setShowNewUserBanner={setShowNewUserBanner} />
                        ) : (
                            
                            <div className="container">
                                {
                                    showAlert ? 
                                        <div className="alert alert-danger" role="alert">
                                            {alertText}
                                        </div> : null
                                }
                                {
                                    showNewUserBanner ?
                                        <div className="alert alert-success" role="alert">
                                            Your account was created successfully. Please login below.
                                        </div> : null
                                }
                                <h1 className="text-center">Login</h1>
                                <form>
                                    <div className="form-group mb-3">
                                        <label htmlFor="emailInput">Email</label>
                                        <input 
                                            id="emailInput"
                                            className="form-control"
                                            type="text"
                                            value={email}
                                            onChange={(event) => setEmail(event.target.value)}
                                            placeholder="Email"
                                        >
                                        </input>
                                    </div>
                                    <div className="form-group mb-3">
                                        <label htmlFor="passwordInput">Password</label>
                                        <input
                                            id="passwordInput"
                                            className="form-control"
                                            type="password"
                                            value={password}
                                            onChange={(event) => setPassword(event.target.value)}
                                            placeholder="Password"
                                        >
                                        </input>
                                    </div>
                                    <div className="text-center">
                                        <button 
                                            className="btn btn-primary mb-3"
                                            onClick={(event) => logIn(event)}
                                        >
                                            Login
                                        </button>
                                        <div className="form-group">
                                            <label htmlFor="signUpButton">New here? Create an account!</label>
                                            <br></br>
                                            <button
                                                id="signUpButton"
                                                className="btn btn-secondary"
                                                onClick={(event) => {
                                                    event.preventDefault();
                                                    setAlertText('');
                                                    setShowAlert(false);
                                                    setShowSignUpForm(true);
                                                }}
                                            >
                                                Sign up
                                            </button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        )
                        }
                    </>
                )
            }
        </>
    );
}

export default Dashboard;