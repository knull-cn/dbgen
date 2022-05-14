CREATE TABLE `sbtest1` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
    /*{{ rownum }}*/
  `k` int(11) NOT NULL DEFAULT '0',
    /*{{ rand.range(1000000,10000000000) }}*/
  `c` char(120) NOT NULL DEFAULT '',
    /*{{ rand.regex('[a-zA-Z ]{120}') }}*/
  `pad` char(60) NOT NULL DEFAULT '',
    /*{{ rand.regex('[a-zA-Z ]{60}') }}*/
  index idx_k (k),
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */
);
