# PhiUSIIL: a one-line rule against ten models

Code, data and result tables for the paper *A One-Line Rule against Ten Models on a Popular Phishing Benchmark and What Near-Perfect Accuracy Really Measures* (ICIIT 2027 submission). Every number, table and figure in the paper is produced by the three notebooks below and saved in `report/`.

## Contents

| Path | What it is |
|---|---|
| `Notebook_A_...ipynb` | Loading, cleaning and deduplication, exploratory analysis, SQL description of the two classes, the root cause of the shortcuts (step 3b), and Figures 1–3 of the paper. Writes `data/processed/phishing.parquet`. |
| `Notebook_B_...ipynb` | Ten-model comparison, feature ladder, one-line rule, TLD holdout with size-matched control, cost and permutation analysis, the added checks of step 6d (hostname-grouped split, rule on the same evaluation sets, 95% Wilson intervals, McNemar tests, domain-disjoint control, cross-dataset test, scheme and prefix normalization, URL length in each source, split grouped by registered domain), and the two figures of step 6c (cost and permutation; the paper prints the permutation figure as Fig. 4). |
| `Notebook_C_...ipynb` | Supplement to the unseen-TLD test of Notebook B: the test repeated on five different 100,000-URL pools and 60/20/20 splits (`random_state` 0 to 4) for all ten models and the 21 address features, each with its size-matched control, at false-alarm budgets of 0.5, 1, 2 and 5%. Split 0 is the split of Notebook B and is checked against `table_rq3_unseen_tld.csv`. It writes only new files and does not alter any result of Notebooks A and B. |
| `sql/queries.sql` | DuckDB queries used by the notebooks. |
| `data/raw/` | PhiUSIIL Phishing URL Dataset (UCI Machine Learning Repository, id 967, CC BY 4.0). |
| `data/external/` | ISCX-URL-2016 benign URLs (`1.Benign_list_big_final.csv`) and verified PhishTank URLs (`2.online-valid.csv`), as redistributed in github.com/shreyagopal/Phishing-Website-Detection-by-Machine-Learning-Techniques (folder `DataFiles`); used only in steps 6d-5 to 6d-7. |
| `report/` | All result tables (`table_*.csv`) and figures; `paper_fig1`–`paper_fig5` are the figures printed in the paper. |

## Reproducing

```
pip install -r requirements.txt
jupyter nbconvert --to notebook --execute --inplace Notebook_A_OnGoingAssessment2_ACDSA_PhishingURL_OneLineRule.ipynb
jupyter nbconvert --to notebook --execute --inplace Notebook_B_OnGoingAssessment2_ACDSA_PhishingURL_OneLineRule.ipynb
jupyter nbconvert --to notebook --execute --inplace Notebook_C_OnGoingAssessment2_ACDSA_PhishingURL_OneLineRule.ipynb
```

`requirements.txt` pins the versions used for the reported run. Timing columns (training seconds, microseconds per URL) depend on the machine and vary between runs, so Notebook B measures them with a fixed protocol: training time is the mean of five timed fits after one untimed warm-up fit (`train_s`, with `train_sd_s`); time per URL is the median of 15 timed batch calls over the 20,000 test URLs after five warm-up calls, with the address columns selected before the clock starts (`microseconds_per_address`, with the interquartile range `iqr_microseconds`). `report/table_timing_environment.csv` records the CPU, cores, operating system and library versions of the machine that produced the times. For comparable times, run Notebook B once on a machine that is plugged in and set to its high-performance power mode, with other programs closed, and quote the times with two significant figures. Models whose fit depends on thread order or on the library build (XGBoost, LightGBM, Random Forest) can differ from the stored outputs in the last printed decimals on another machine; the tables in `report/` are the ones used in the paper.

## Where each result in the paper comes from

| Paper | Notebook step | Table in `report/` |
|---|---|---|
| Cleaning (235,795 / 425 / 235,370 / 695 TLDs) | A, step 2 | `table_cleaning_log.csv` |
| Fig. 2, class differences (lengths, HTTPS, prefix, similarity bins) | A, step 3 (Q1, Q3) | `table_q1.csv`, `table_q3.csv` |
| Fig. 3, TLD composition | A, step 3 (Q2) | `table_q2.csv` |
| Spearman correlations | A, step 2b.8 | `table_eda_correlation.csv` |
| Root cause of the shortcuts | A, step 3b | `table_root_cause.csv` |
| Split sizes, standardized mean difference | B, steps 4 and 4b.2 | `table_split_shift.csv` |
| Table 2, ten models on the standard split | B, step 6a | `table_rq2.csv` |
| Hostname-grouped split | B, step 6d-1 | `table_review_grouped_split.csv` |
| Table 3, feature ladder | B, step 6b | `table_rq3_feature_ladder.csv` |
| One-line rule on all URLs, ROC-AUC of the index | B, step 6b | `table_rq3_one_line_rule.csv` |
| Table 4, rule and models on the same sets | B, steps 6b, 6d-1, 6d-2, 6d-5 | `table_review_rule_sets.csv`, `table_rq3_feature_ladder.csv`, `table_review_grouped_split.csv`, `table_rq3_unseen_tld.csv`, `table_review_cross_dataset.csv`, `table_review_cross_info.csv`, `table_review_cross_normalised.csv` |
| Table 5, TLD holdout with 95% intervals and control | B, steps 6b, 6b-2, 6d-2, 6d-4 | `table_rq3_unseen_tld.csv`, `table_rq3_size_matched_control.csv`, `table_review_heldout_ci.csv`, `table_review_control_domain_disjoint.csv` |
| Linear SVM score quantiles, ties of k-NN and the decision tree | B, step 6b-3 | `table_rq3_svm_score_quantiles.csv`, `table_rq3_threshold_diagnostic.csv` |
| Table 6, cost | B, step 6c | `table_rq3_cost.csv` |
| McNemar tests | B, step 6d-3 | `table_review_mcnemar.csv` |
| Fig. 4, permutation | B, step 6c | `table_rq3_address_features.csv` |
| Cross-dataset test | B, step 6d-5 | `table_review_cross_dataset.csv`, `table_review_cross_info.csv` |
| Scheme of each source, features the recomputation does not reproduce, cross-dataset test after prefix normalization (retrained models, thresholds chosen again; 18 features recomputed, 17 after normalization) | B, step 6d-6 and its feature-count cell | `table_review_cross_scheme.csv`, `table_review_cross_feature_offsets.csv`, `table_review_cross_normalised.csv` |
| URL length and scheme in each source; URL length alone as a score (external ROC-AUC below 0.5) | B, step 6d-7 | `table_review_cross_length.csv`, `table_review_cross_length_auc.csv` |
| Registered-domain overlap of the splits; ten models on a split grouped by registered domain | B, step 6d-8 | `table_review_registered_domain_overlap.csv`, `table_review_grouped_registered.csv` |
| Unseen-TLD test on five splits with controls; false-alarm budgets of 0.5 to 5% | C, steps 2 to 5 | `table_review_tld_splits.csv`, `table_review_tld_splits_info.csv`, `table_review_tld_splits_summary.csv`, `table_review_fa_budget.csv` |
