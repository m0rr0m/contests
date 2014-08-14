(ns fpsf-1408.core
  (:gen-class)
  (:require [clojure.string :refer [split-lines]]
            [criterium.core :as criterium]
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

(defn solve [matrix char->repr]
  (keep (fn [[i j b]]
          (some (fn [[char repr]]
                  (when (= b repr) [i j char]))
                char->repr))
        (blocks matrix 3 5)))

(defn ->matrix [x]
  (->> x slurp split-lines (mapv vec)))

(defn -main [x]
  (let [matrix (->matrix x)]
    (criterium/bench (dorun (solve matrix data/char->repr)))
    #_(doseq [[i j c] (solve matrix data/char->repr)]
        (println c \@ i j))))
