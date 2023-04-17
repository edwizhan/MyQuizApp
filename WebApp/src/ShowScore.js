import React from "react";
import { PieChart } from "react-minimal-pie-chart";
import './ShowScore.css';

const ShowScore = ({ numCorrect, totalQuestions, handleAnotherQuiz }) => {
  return (
    <div>
      <h2 className="yourScore">Your Score: </h2>
      <div className="scoreContainer">
        <PieChart
          data={[
            //{
              //title: "Incorrect",
              //value: totalQuestions - numCorrect,
              //color: "#CCCCCC",
            //},
            {
              title: "Correct",
              value: numCorrect,
              color: "#0077CC",
              total: totalQuestions
            },
          ]}
          lineWidth={16}
          rounded
          animate
          startAngle={-90}
          label={({ dataEntry }) =>
            dataEntry.title === "Correct" ? `${Math.round(dataEntry.percentage)}%` : ""
          }
          labelStyle={(index) => ({
            fill: index === 0 ? "#0077cc" : "transparent",
            fontSize: "20px",
            fontFamily: "Arial, sans-serif",
            fontWeight: "bold",
          })}
          labelPosition={({ dataEntry }) =>
            dataEntry.title === "Correct" ? 0 : 60
          }
          lengthAngle={360}
          totalValue={totalQuestions}
          background="#ddd"
        />
      </div>
      <p className="thanks">Thanks for playing!</p>
      <button className="AnotherQuiz__button" onClick={handleAnotherQuiz}>
        Start Another Quiz
      </button>
    </div>
  );
};

export default ShowScore;
