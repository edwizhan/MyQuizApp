import React from 'react';
import './WelcomeScreen.css';

function WelcomeScreen({ onStartQuiz }) {
  return (
    <div className="welcome-screen">
      <h1 className="welcome-screen__title">Welcome to the Coding Quiz Game!</h1>
      <button className="welcome-screen__button" onClick={onStartQuiz}>Start Quiz</button>
    </div>
  );
}

export default WelcomeScreen;
