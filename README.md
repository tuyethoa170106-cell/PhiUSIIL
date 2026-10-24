# PhiUSIIL: a one-line rule against ten models

Code, data and result tables for the paper *A One-Line Rule against Ten Models on a Popular Phishing Benchmark and What Near-Perfect Accuracy Really Measures* (ICIIT 2027 submission). Every number, table and figure in the paper is produced by the two notebooks below and saved in `report/`.

## Contents

| Path | What it is |
|---|---|
| `Notebook_A_...ipynb` | Loading, cleaning and deduplication, exploratory analysis, SQL description of the two classes, the root cause of the shortcuts (step 3b), and Figures 1–3 of the paper. Writes `data/processed/phishing.parquet`. |
| `Notebook_B_...ipynb` | Ten-model comparison, feature ladder, one-line rule, TLD holdout with size-matched control, cost and permutation analysis, the added checks of step 6d (domain-grouped split, rule on the same evaluation sets, 95% Wilson intervals, McNemar tests, domain-disjoint control, cross-dataset test), and Figures 4–5. |
| `sql/queries.sql` | DuckDB queries used by both notebooks. |
| `data/raw/` | PhiUSIIL Phishing URL Dataset (UCI Machine Learning Repository, id 967, CC BY 4.0). |
| `data/external/` | ISCX-URL-2016 benign URLs (`1.Benign_list_big_final.csv`) and verified PhishTank URLs (`2.online-valid.csv`), as redistributed in github.com/shreyagopal/Phishing-Website-Detection-by-Machine-Learning-Techniques (folder `DataFiles`); used only in step 6d-5. |
| `report/` | All result tables (`table_*.csv`) and figures; `paper_fig1`–`paper_fig5` are the figures printed in the paper. |

## Reproducing

```
pip install -r requirements.txt
jupyter nbconvert --to notebook --execute --inplace Notebook_A_OnGoingAssessment2_ACDSA_PhishingURL_OneLineRule.ipynb
jupyter nbconvert --to notebook --execute --inplace Notebook_B_OnGoingAssessment2_ACDSA_PhishingURL_OneLineRule.ipynb
```

`requirements.txt` pins the versions used for the reported run. Timing columns (training seconds, microseconds per URL) depend on the machine.

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
| Domain-grouped split | B, step 6d-1 | `table_review_grouped_split.csv` |
| Table 3, feature ladder | B, step 6b | `table_rq3_feature_ladder.csv` |
| One-line rule on all URLs, ROC-AUC of the index | B, step 6b | `table_rq3_one_line_rule.csv` |
| Table 4, rule and models on the same sets | B, steps 6b, 6d-1, 6d-2, 6d-5 | `table_review_rule_sets.csv`, `table_rq3_feature_ladder.csv`, `table_review_grouped_split.csv`, `table_rq3_unseen_tld.csv`, `table_review_cross_dataset.csv`, `table_review_cross_info.csv` |
| Table 5, TLD holdout with 95% intervals and control | B, steps 6b, 6b-2, 6d-2, 6d-4 | `table_rq3_unseen_tld.csv`, `table_rq3_size_matched_control.csv`, `table_review_heldout_ci.csv`, `table_review_control_domain_disjoint.csv` |
| Linear SVM score quantiles, ties of k-NN and the decision tree | B, step 6b-3 | `table_rq3_svm_score_quantiles.csv`, `table_rq3_threshold_diagnostic.csv` |
| Fig. 4 and Table 6, cost | B, step 6c | `table_rq3_cost.csv` |
| McNemar tests | B, step 6d-3 | `table_review_mcnemar.csv` |
| Fig. 5, permutation | B, step 6c | `table_rq3_address_features.csv` |
| Cross-dataset test | B, step 6d-5 | `table_review_cross_dataset.csv`, `table_review_cross_info.csv` |
