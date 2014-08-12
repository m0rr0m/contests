import scala.collection.immutable.BitSet
import scala.io.StdIn;

object Recognize extends App {

  val symbolsData: Map[Int, Seq[Seq[Int]]] =
    Map(
      0 ->
        Seq(
          Seq(1, 1, 1),
          Seq(1, 0, 1),
          Seq(1, 0, 1),
          Seq(1, 0, 1),
          Seq(1, 1, 1)),
      1 ->
        Seq(
          Seq(1, 1, 0),
          Seq(0, 1, 0),
          Seq(0, 1, 0),
          Seq(0, 1, 0),
          Seq(1, 1, 1)),
      2 ->
        Seq(
          Seq(1, 1, 1),
          Seq(0, 0, 1),
          Seq(1, 1, 1),
          Seq(1, 0, 0),
          Seq(1, 1, 1)),
      3 ->
        Seq(
          Seq(1, 1, 1),
          Seq(0, 0, 1),
          Seq(1, 1, 1),
          Seq(0, 0, 1),
          Seq(1, 1, 1)),
      4 ->
        Seq(
          Seq(1, 0, 1),
          Seq(1, 0, 1),
          Seq(1, 1, 1),
          Seq(0, 0, 1),
          Seq(0, 0, 1)),
      5 ->
        Seq(
          Seq(1, 1, 1),
          Seq(1, 0, 0),
          Seq(1, 1, 1),
          Seq(0, 0, 1),
          Seq(1, 1, 1)),
      6 ->
        Seq(
          Seq(1, 1, 1),
          Seq(1, 0, 0),
          Seq(1, 1, 1),
          Seq(1, 0, 1),
          Seq(1, 1, 1)),
      7 ->
        Seq(
          Seq(1, 1, 1),
          Seq(0, 0, 1),
          Seq(0, 1, 1),
          Seq(0, 1, 0),
          Seq(0, 1, 0)),
      8 ->
        Seq(
          Seq(1, 1, 1),
          Seq(1, 0, 1),
          Seq(1, 1, 1),
          Seq(1, 0, 1),
          Seq(1, 1, 1)),
      9 ->
        Seq(
          Seq(1, 1, 1),
          Seq(1, 0, 1),
          Seq(1, 1, 1),
          Seq(0, 0, 1),
          Seq(1, 1, 1)))

  val symbolWidth = 3
  val symbolHeight = 5

  def input: Iterator[String] =
    Iterator.continually(StdIn.readLine()).takeWhile(null !=)

  def data: Iterator[Seq[Boolean]] =
    input.map(_.trim.map('1' ==))

  // Функция для перевода матрицы булевских значений в битсет
  def bitSet(bss: Seq[Seq[Boolean]]): BitSet =
    BitSet(bss.flatten.zipWithIndex.filter(_._1).map(_._2): _*)
  // Словарь для поиска цифры по матрице
  val symbolsMap: Map[BitSet, Int] =
    for {
      (k, v) <- symbolsData
      bits = bitSet(v.map(_.map(1 ==)))
    } yield bits -> k

  object Digit {
    def unapply(data: Seq[Seq[Boolean]]): Option[Int] = symbolsMap.get(bitSet(data))
  }

  // Основной цикл: проходим перебором по всей таблице.
  // Если цифры расположены с известными закономерностями (как в примере), это можно использовать для ускорения алгоритма.
  def resultLines =
    for {
    //Выбираем все возможные ряды-полосы
      (row, y) <- data.sliding(symbolHeight).zipWithIndex
      //В каждой полосе выбираем все возможные матрицы цифр. Тут же происходит и поиск цифры.
      (Digit(n), x) <- row.map(_.sliding(symbolWidth).toList).transpose.zipWithIndex
    } yield s"$n @ ($x, $y)"

  resultLines.foreach(println)
}