import { useState, useEffect } from "react";
import db from "./firebase";
import { collection, doc, getDoc, getDocs } from "firebase/firestore";

const useQuestions = () => {
  const [questions, setQuestions] = useState([]);
  const [isLoading, setIsLoading] = useState(true);

  const fetchQuestions = async () => {
    setIsLoading(true);
    const infoRef = doc(db, "Quiz", "Coding_questions_info");
    const infoSnap = await getDoc(infoRef);
    const totalQuestions = infoSnap.data().totalQuestions;

    const numQuestions = 3;
    const randomIds = getRandomIds(numQuestions, totalQuestions);
    const fetchedQuestions = [];
    
    try {
      const fetchPromises = randomIds.map(id => {
        const questionsRef = collection(db, `Quiz/${id}/Coding_questions`);
        return getDocs(questionsRef);
      });
    
      const querySnapshots = await Promise.all(fetchPromises);
    
      querySnapshots.forEach(querySnapshot => {
        querySnapshot.forEach(doc => {
          fetchedQuestions.push(doc.data());
        });
      });
    } catch (error) {
      console.error("Error fetching random questions:", error);
    }
  
    setQuestions(fetchedQuestions);
    setIsLoading(false);
  };

  useEffect(() => {
    fetchQuestions();
  }, []);

  const getRandomIds = (n, totalQuestions) => {
    const randomIds = new Set();
    while (randomIds.size < n) {
      const randomId = Math.floor(Math.random() * totalQuestions) + 1; // Assuming the ids start from 1
      randomIds.add(randomId);
    }
    return Array.from(randomIds);
  };

  return { questions, isLoading, fetchQuestions };
};

export default useQuestions;
