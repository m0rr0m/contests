(ns fpsf-1408.core
  (:gen-class)
  (:require [clojure.core.reducers :as r]
            [clojure.java.io :as io]
            [criterium.core :as criterium]
            [fpsf-1408.data :as data]))

(defn block [matrix i j width height]
  (let [i-end (+ i height) j-end (+ j width)]
    (for [i (range i i-end)]
      (-> i matrix (subvec j j-end)))))

(defn blocks [width height matrix]
  (let [m (count matrix)
        n (-> 0 matrix count)
        is (->> height dec (- m) range)
        js (->> width dec (- n) range)]
    (r/mapcat (fn [i]
                (r/map (fn [j]
                         [i j (block matrix i j width height)])
                       js))
            is)))

(defn solve [char->repr matrix]
  (let [valz (vals char->repr)
        reprs (set valz)
        repr->char (zipmap valz (keys char->repr))]
    (->> matrix
      (blocks 3 5)
      (r/filter (fn [[_ _ b]]
                  (reprs b)))
      (r/map (fn [[i j b]]
               [i j (repr->char b)]))
      r/foldcat))) ; TODO: fold lazily

(defn ->matrix [in]
  (with-open [reader (io/reader in)]
    (->> reader
      line-seq
      (mapv vec))))

(defn -solve [in]
  (solve data/char->repr (->matrix in)))

#_(defn bench [in]
    (criterium/bench (dorun (-solve in))))

(defn -main [in]
  (doseq [[i j c] (-solve in)]
    (println c \@ i j)))
