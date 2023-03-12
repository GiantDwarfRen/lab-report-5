CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'
# For Windows, revise CPATH to CPATH='.;lib/hamcrest-core-1.3.jar;lib/junit-4.13.2.jar'

rm -rf student-submission *.class *.txt ListExamples.java

git clone $1 student-submission 2>clone-result.txt
if [[ $? -ne 0 ]]
then 
    echo -e '\nClone Failed.'
    cat clone-result.txt
    exit
fi

echo -e '\nFinished cloning'

if [[ -f student-submission/ListExamples.java ]]
then
    cp student-submission/ListExamples.java ./
else
    echo -e 'student-submission/ListExamples.java not found'
    exit
fi

javac -cp $CPATH *.java 2>compile-err.txt
if [[ $? -ne 0 ]]
then
    echo -e 'Compile Failed'
    cat compile-err.txt
    exit
fi


java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > exec-result.txt

grep "@Test" TestListExamples.java > number-tests.txt
TotalPoints=`wc -l < number-tests.txt`

grep ") " exec-result.txt > failed-tests.txt
LostPoints=`wc -l < failed-tests.txt`

let EarnedPoints=TotalPoints-LostPoints

echo -e '\nScore:'
echo -e $EarnedPoints " / " $TotalPoints

if [[ $EarnedPoints -ne $TotalPoints ]]
then 
    echo -e '\nFailed Tests Summary:'
    cat failed-tests.txt
fi

echo -e '\nAuto grading done\nThanks for using!'

