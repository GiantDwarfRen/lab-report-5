# Lab Report 5
Here I decide to finish `grade.sh` and demo it's features. 
## code overview
Below is the finished grader script overview
```
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


```
## Analysis
```
rm -rf student-submission *.class *.txt ListExamples.java
```
remove all .txt files. Here, .txt files are used for standard output and standard error message. Also, it's used for grep to calculate grade.
```
git clone $1 student-submission 2>clone-result.txt
if [[ $? -ne 0 ]]
then 
    echo -e '\nClone Failed.'
    cat clone-result.txt
    exit
fi

echo -e '\nFinished cloning'
```
Clone the grading url. exit if clone fail.

Also, it redirects clone message to clone-result.txt. So, instead of showing all cloning process, only "Finished clone" or "Clone Filaed" will be displayed. Much more clean and precise.
```
if [[ -f student-submission/ListExamples.java ]]
then
    cp student-submission/ListExamples.java ./
else
    echo -e 'student-submission/ListExamples.java not found'
    exit
fi
```
If if desired submission file exist. If exist, copy to current working directly; otherwise, output error message.
```
javac -cp $CPATH *.java 2>compile-err.txt
if [[ $? -ne 0 ]]
then
    echo -e 'Compile Failed'
    cat compile-err.txt
    exit
fi
```
Compile java files and redirect compile error message to compile-err.txt. If compile fails, report error message stored in compile-err.txt and exit.
```
java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > exec-result.txt
```
Execute TestListExamples class, and redirect test result to exec-result.txt
```
grep "@Test" TestListExamples.java > number-tests.txt
TotalPoints=`wc -l < number-tests.txt`

grep ") " exec-result.txt > failed-tests.txt
LostPoints=`wc -l < failed-tests.txt`

let EarnedPoints=TotalPoints-LostPoints
```
Grep failed test name to failed-tests.txt by grepping ") ". 

Calculate total number of tests (`TotalPoints`), and number of failing tests(`LostPoints`). Calculate credits student earned to `EarnedPoints` by `TotalPoints` minus `LostPoints`.
```
echo -e '\nScore:'
echo -e $EarnedPoints " / " $TotalPoints

if [[ $EarnedPoints -ne $TotalPoints ]]
then 
    echo -e '\nFailed Tests Summary:'
    cat failed-tests.txt
fi

echo -e '\nAuto grading done\nThanks for using!'
```
Format output. If student did not get full credit, report failed tests name stored in failed-tests.txt.

## Test Cases
There are totally 10 tests cases: 9 tests and 1 extra credit assigned to student for submitting homework.

![test_cases](./Images/test_cases.png)

## Different Submision Results
1. https://github.com/ucsd-cse15l-f22/list-methods-lab3, which has the same code as the starter from lab 3

![1](./Images/1.png)

2. https://github.com/ucsd-cse15l-f22/list-methods-corrected, which has the methods corrected (I would expect this to get full or near-to-full credit)

![2](./Images/2.png)

3. https://github.com/ucsd-cse15l-f22/list-methods-compile-error, which has a syntax error of a missing semicolon. Note that your job is not to fix this, but to decide what to do in your grader with such a submission!

![3](./Images/3.png)

4. https://github.com/ucsd-cse15l-f22/list-methods-signature, which has the types for the arguments of filter in the wrong order, so it doesn’t match the expected behavior.

![4](./images/4.png)

5. https://github.com/ucsd-cse15l-f22/list-methods-filename, which has a great implementation saved in a file with the wrong name.

![5](./Images/5.png)

6. https://github.com/ucsd-cse15l-f22/list-methods-nested, which has a great implementation saved in a nested directory called pa1.

![6](./Images/6.png)

7. Challenge https://github.com/ucsd-cse15l-f22/list-examples-subtle, which has more subtle bugs (hints: see assertSame, which compares with == rather than .equals(), and think hard about duplicates for merge)

![7](./Images/7.png)