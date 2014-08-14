(ns fpsf-1408.core
  (:gen-class)
  (:require [clojure.string :as str]
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

(defn solve [char->repr matrix]
  (keep (fn [[i j b]]
          (some (fn [[char repr]]
                  (when (= b repr) [i j char]))
                char->repr))
        (blocks matrix 3 5)))

(defn -solve [in]
  (->> in
    slurp
    str/split-lines
    (mapv vec)
    (solve data/char->repr)))

(defn bench [in]
  (criterium/bench (dorun (-solve in))))

(defn -main [in]
  (doseq [[i j char] (-solve in)]
    (println char \@ i j)))
