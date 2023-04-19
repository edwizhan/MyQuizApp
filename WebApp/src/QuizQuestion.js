import React, { useState } from 'react';
import './QuizQuestion.css';

function QuizQuestion({ question, handleAnswer, index, numQuestions }) {
  const [selectedAnswer, setSelectedAnswer] = useState(null);
  const [resultMessage, setResultMessage] = useState({ text: '', cssClass: '' });
  const [isSubmitted, setIsSubmitted] = useState(false);

  const handleSelectAnswer = (answerId) => {
    if (!isSubmitted) {
      setSelectedAnswer(answerId);
    }
  };

  const handleSubmitAnswer = () => {
    setIsSubmitted(true);
    const isCorrect = selectedAnswer === question.correctAnswer;
    setResultMessage({
      text: isCorrect ? 'Correct!' : 'Oops!',
      cssClass: isCorrect ? 'correct' : 'incorrect',
    }); 
  
    setTimeout(() => {
      handleAnswer(selectedAnswer);
      setSelectedAnswer(null);
      setResultMessage('');
      setIsSubmitted(false);
    }, 1000);
  };
  

  const progress = ((index + 1) / numQuestions) * 100;

  return (
    <div>
      <div className="progress-bar">
        <div style={{ width: `${progress}%` }}></div>
      </div>
      <h2 className="question-text">{question.text}</h2>
      <ul className="choices">
        {question.choices.map((choice) => (
          <li
            key={choice.id}
            onClick={() => handleSelectAnswer(choice.id)}
            className={`choice ${selectedAnswer === choice.id ? 'selected' : ''}`}
          >
            {choice.text}
          </li>
        ))}
      </ul>
      <button className="button" disabled={!selectedAnswer} onClick={handleSubmitAnswer}>
        Submit Answer
      </button>
      {resultMessage.text && (
  <div className={`result-message ${resultMessage.cssClass}`}>
    {resultMessage.text}
  </div>
)}
    </div>
  );
}

export default QuizQuestion;
