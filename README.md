algospot-pc2-validator
========================

java -jar Validator.jar #{input} #{output} #{answer} #{resfile} #{preprocess} [#{validator} [#{args}]]

전처리
--------------

* l Strip left(leading) whitespaces
* r Strip right(trailing) whitespaces
* a Strip all whitespaces
* z Strip last empty line
* e Strip empty lines
* i Ignore cases

단순 비교
---------------

validator를 지정하지 않으면 내장 SimpleValidator를 사용.

실수 비교
---------------

java -jar .... FloatValidator 1e-7
