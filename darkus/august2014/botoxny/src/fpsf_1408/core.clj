(ns fpsf-1408.core
  (:require [clojure.string :refer [split-lines]]
            [fpsf-1408.data :as data]))

(defn block [matrix i j width height]
  (let [i-end (+ i height) j-end (+ j width)]
    (for [i (range i i-end)]
      (-> i matrix (subvec j j-end)))))

(defn blocks [matrix width height]
  (let [m (count matrix)
        n (-> matrix first count)
        is (->> height dec (- m) range)
        js (->> width dec (- n) range)]
    (for [i is j js]
      [i j (block matrix i j width height)])))

(defn solve [matrix charz]
  (for [[i j block] (blocks matrix 3 5)
        [c repr] charz
        :when (= block repr)]
    [i j c]))

(defn -main [& args]
  (let [matrix (->> args first slurp split-lines (mapv vec))]
    (doseq [[i j c] (-> (solve matrix data/charz) doall time)]
      (println c \@ i j))))
