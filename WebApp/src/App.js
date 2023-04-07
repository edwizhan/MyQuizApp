import React, { useState, useEffect } from "react";
import './App.css';
import QuizQuestion from './QuizQuestion';
import WelcomeScreen from './WelcomeScreen';
import useQuestions from "./useQuestions";
import ShowScore from "./ShowScore";
import ConfettiAnimation from "./ConfettiAnimation";

function App() {
  const [quizStarted, setQuizStarted] = useState(false);
  const [currentQuestionIndex, setCurrentQuestionIndex] = useState(0);
  const [userAnswers, setUserAnswers] = useState([]);
  const [showScore, setShowScore] = useState(false);
  const [showConfetti, setShowConfetti] = useState(false);
  const { questions, isLoading, fetchQuestions } = useQuestions();

  const handleAnswer = (answer) => {
    setUserAnswers([...userAnswers, answer]);
    handleNextQuestion();
  };

  const handleNextQuestion = () => {
    if (currentQuestionIndex < questions.length - 1) {
      setCurrentQuestionIndex(currentQuestionIndex + 1);
    } else if (currentQuestionIndex === questions.length - 1) {
      // Quiz is over
      setShowConfetti(true);
      setShowScore(true);
    } else {
      // An error occurred
      alert('An error occurred. Please start the quiz again.');
    }
  };

  const handleConfettiAnimationEnd = () => {
    setShowConfetti(false);
  };
  
  const currentQuestion = questions[currentQuestionIndex];

  const handleStartQuiz = () => {
    setQuizStarted(true);
  }

  const handleAnotherQuiz = async () => {
    setQuizStarted(false);
    setShowScore(false);
    setCurrentQuestionIndex(0);
    setUserAnswers([]);
    setShowConfetti(false);
    await fetchQuestions(); 
  }

  const numCorrect = userAnswers.filter((answer, index) => answer === questions[index]?.correctAnswer).length;

  return (
    <div className="App">
    {isLoading ? (
      <div>Loading...</div>
    ) : quizStarted ? (
      <>
        {showConfetti && (
          <ConfettiAnimation show={showConfetti} onAnimationEnd={handleConfettiAnimationEnd} />
        )}
        {showScore ? (
          <ShowScore
            numCorrect={numCorrect}
            totalQuestions={questions.length}
            handleAnotherQuiz={handleAnotherQuiz}
          />
        ) : (
            <>
             {currentQuestion && (
              <QuizQuestion
                question={currentQuestion}
                handleAnswer={handleAnswer}
                index={currentQuestionIndex}
                numQuestions={questions.length}
              />
            )}
          </>
          )}
        </>
      ) : (
        <WelcomeScreen onStartQuiz={handleStartQuiz} />
      )}
    </div>
  );
}

export default App;
