import React, {useState} from "react";

const Signup = (props) => {

    const {setShowSignUpForm, setShowNewUserBanner} = props;
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [firstName, setFirstName] = useState('');
    const [lastName, setLastName] = useState('');
    const [showAlert, setShowAlert] = useState(false);
    const [alertText, setAlertText] = useState('');

    const signUp = async (event) => {
        event.preventDefault();
        
        setShowAlert(false);
        setAlertText("");

        if(!email || !password || !firstName || !lastName) {
            setAlertText("Please enter valid values for all the fields to signup.")
            setShowAlert(true);
            return;
        }

        if(email === "" || password === "" || firstName === "" || lastName === "") {
            setAlertText("Please enter valid values for all the fields to signup.")
            setShowAlert(true);
            return;
        }

        const signUpRequestBody = {
            email: email,
            password: password,
            firstName: firstName,
            lastName: lastName
        }

        console.log(signUpRequestBody);

        try {
            const response = await fetch(`${process.env.REACT_APP_API_BASE}/user`, {
                method: "POST",
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(signUpRequestBody)
            });

            if(response.status === 200) {
                const textResponse = await response.text();
                console.log(textResponse);
                setShowNewUserBanner(true);
                setShowSignUpForm(false);
            }
            else {
                if(response.status === 409) {
                    setAlertText("An account with this email already exists. Please login instead.")
                    setShowAlert(true);
                }
                else {
                    setAlertText("There was an error creating your account. Please try again later.")
                    setShowAlert(true);
                }
            }
        }
        catch (err) {
            console.log(err);
            setAlertText("There was an error creating your account. Please try again later.")
            setShowAlert(true);
        }

    }

    return(
        <div className="container">
            {
                showAlert ? 
                    <div className="alert alert-danger" role="alert">
                        {alertText}
                    </div> : null
            }
            <h1 className="text-center">Sign Up</h1>
            <form>
                <div className="row mb-3">
                    <div className="col-sm">
                        <label htmlFor="firstNameInput">First Name</label>
                        <input 
                            id="firstNameInput"
                            className="form-control"
                            type="text"
                            placeholder="John"
                            value={firstName}
                            onChange={(event) => setFirstName(event.target.value)}
                        />
                    </div>
                    <div className="col-sm">
                        <label htmlFor="lastNameInput">Last Name</label>
                        <input 
                            id="lastNameInput"
                            className="form-control"
                            type="text"
                            placeholder="Doe"
                            value={lastName}
                            onChange={(event) => setLastName(event.target.value)}
                        />
                    </div>
                </div>
                <div className="form-group mb-3">
                    <label htmlFor="emailInput">Email</label>
                    <input 
                        id="emailInput"
                        className="form-control"
                        type="text"
                        value={email}
                        onChange={(event) => setEmail(event.target.value)}
                        placeholder="john.doe@email.com"
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
                        placeholder="Set a secure password"
                    >
                    </input>
                </div>
                
                <div className="text-center">
                    <button 
                        className="btn btn-primary mb-3"
                        onClick={(event) => signUp(event)}
                    >
                        Create An Account
                    </button>
                    <div className="form-group">
                        <label htmlFor="signUpButton">Already have an account?</label>
                        <br></br>
                        <button
                            id="signUpButton"
                            className="btn btn-secondary"
                            onClick={(event) => {
                                event.preventDefault();
                                setShowSignUpForm(false);
                            }}
                        >
                            Login
                        </button>
                    </div>
                </div>
            </form>
        </div>
    );
}

export default Signup;