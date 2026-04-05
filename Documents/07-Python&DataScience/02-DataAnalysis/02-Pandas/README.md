# Pandas - Curriculum

## Module 1: Series & DataFrame
- [ ] `pd.Series` and `pd.DataFrame` creation
- [ ] Reading data: `read_csv`, `read_excel`, `read_json`, `read_sql`
- [ ] Writing data: `to_csv`, `to_excel`, `to_json`
- [ ] `head()`, `tail()`, `info()`, `describe()`, `shape`, `dtypes`
- [ ] Selecting: `[]`, `loc[]` (label), `iloc[]` (position)
- [ ] Setting and resetting index

## Module 2: Data Manipulation
- [ ] Filtering rows with boolean conditions
- [ ] Adding/removing columns
- [ ] `apply()`, `map()`, `applymap()`
- [ ] String operations: `str.contains()`, `str.replace()`, `str.split()`
- [ ] Sorting: `sort_values()`, `sort_index()`
- [ ] Renaming columns: `rename()`
- [ ] `replace()` and `map()` for value transformation

## Module 3: GroupBy & Aggregation
- [ ] `groupby()` - split-apply-combine
- [ ] Aggregation functions: `sum`, `mean`, `count`, `min`, `max`
- [ ] `agg()` with multiple functions
- [ ] `transform()` - group-level computation keeping original shape
- [ ] Pivot tables: `pivot_table()`, `crosstab()`
- [ ] `melt()` and `stack()`/`unstack()` for reshaping

## Module 4: Merging & Joining
- [ ] `merge()` - SQL-like joins (inner, left, right, outer)
- [ ] `concat()` - stacking DataFrames
- [ ] `join()` - index-based joining
- [ ] Handling duplicate columns
- [ ] Multi-index DataFrames

## Module 5: Time Series
- [ ] `pd.to_datetime()` parsing
- [ ] DatetimeIndex and date range (`pd.date_range()`)
- [ ] Resampling: `resample('M')`, `resample('W')`
- [ ] Rolling windows: `rolling()`, `expanding()`
- [ ] Shift and lag: `shift()`, `diff()`, `pct_change()`
- [ ] Time zone handling

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Explore and clean a Kaggle dataset |
| Module 3 | Sales analysis with groupby and pivot tables |
| Module 4 | Merge multiple datasets (e.g., orders + customers + products) |
| Module 5 | Stock price analysis with rolling averages |

## Key Resources
- Pandas official documentation
- Python for Data Analysis - Wes McKinney
