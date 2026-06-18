# Sprint 3: dbt — Models, Tests & CI on Redshift Serverless

**Course:** Zoltan Toth & Miklos Petridisz — "The Complete dbt (Data Build Tool) Bootcamp" (Udemy)

**Note:** The course uses Snowflake. We watch for concepts and apply them to Redshift Serverless instead. Skip all Snowflake-specific setup videos.

---

## Day 1 — What is dbt + First Models + Materializations

### Videos to Watch (~35 min)
| # | Video Title | Section | Duration |
|---|------------|---------|----------|
| 1 | What is dbt and Why should you use it? | Section 1 | 5 min |
| 2 | Use-case and Input Data Model Overview | Section 2 | 6 min |
| 3 | Datasets and Data Flow Overview | Section 2 | 5 min |
| 4 | Models Overview | Section 3 | 1 min |
| 5 | Theory: CTE - Common Table Expressions | Section 3 | 3 min |
| 6 | Creating our first model: Airbnb listings | Section 3 | 11 min |
| 7 | Materializations Overview | Section 4 | 4 min |
| | **Total** | | **~35 min** |

**Skip from Section 2:** Snowflake Registration (3 min), Snowflake's Authentication types (4 min), Automatic Snowflake Data Import (3 min), ONLY FOR REFERENCE - Snowflake Behind the Scenes (14 min), dbt Roles/Users/Database Tables (3 min), Installing dbt (6 min — we'll install for Redshift instead), dbt Project Setup (8 min — different for Redshift), Say Hello to our dbt Project Folder (3 min), Visual Studio Code Extensions Overview (6 min)

### Optional Reading (O'Reilly)
- "Data Engineering with dbt" Ch. 1-2: What problems dbt solves, how it fits in the modern data stack
- "Fundamentals of Data Engineering" (Reis & Housley) — section on transformation patterns (why ELT > ETL for cloud warehouses)

### Then Build
- Terraform: provision Redshift Serverless
- Install dbt-redshift adapter
- Initialize dbt project, configure connection
- Load Amazon Product Reviews into Redshift external schema
- Create first staging model: `stg_reviews.sql`

---

## Day 2 — Materializations + ref + Sources

### Videos to Watch (~37 min)
| # | Video Title | Section | Duration |
|---|------------|---------|----------|
| 1 | Model Dependencies and dbt's ref tag | Section 4 | 10 min |
| 2 | Table type materialization & Project-level Materialization config | Section 4 | 3 min |
| 3 | Incremental materialization | Section 4 | 8 min |
| 4 | Incremental Strategies | Section 4 | 2 min |
| 5 | Ephemeral materialization | Section 4 | 10 min |
| 6 | Sources | Section 5 | 4 min |
| | **Total** | | **~37 min** |

**Skip:** Seeds and Sources Overview (1 min — redundant), Seeds (5 min — not using seed files), Source Freshness Checks (4 min — covered on Day 3)

### Optional Reading (O'Reilly)
- "Data Engineering with dbt" Ch. 3: Materializations in depth — when to use view vs table vs incremental
- "The Data Warehouse Toolkit" (Kimball) Ch. 1: Dimensional modeling fundamentals (context for marts layer)

### Then Build
- Define sources in `_sources.yml`
- Build intermediate model: `int_reviews_enriched.sql`
- Build marts: `fct_product_reviews.sql`
- Configure materializations per folder in `dbt_project.yml`

---

## Day 3 — Tests + Source Freshness + Packages

### Videos to Watch (~35 min)
| # | Video Title | Section | Duration |
|---|------------|---------|----------|
| 1 | Source Freshness Checks | Section 5 | 4 min |
| 2 | Tests Overview | Section 7 | 2 min |
| 3 | Generic Tests | Section 7 | 6 min |
| 4 | Debugging dbt Tests | Section 7 | 2 min |
| 5 | Saving Test Failures to the Data Warehouse | Section 7 | 2 min |
| 6 | Singular Tests | Section 7 | 2 min |
| 7 | Unit Tests | Section 7 | 4 min |
| 8 | Data Contracts | Section 8 | 5 min |
| 9 | Custom Generic Tests | Section 8 | 3 min |
| 10 | Setting the Tests' Severity: Warning vs Error | Section 8 | 2 min |
| 11 | Installing Third-Party Packages | Section 9 | 12 min |
| | **Total** | | **~44 min** (watch at 1.25x = ~35 min) |

### Optional Reading (O'Reilly)
- "Data Engineering with dbt" Ch. 5: Testing strategies — schema tests, data tests, freshness
- "Data Quality Fundamentals" (Barr Moses) Ch. 1-2: Dimensions of data quality (freshness, volume, schema)

### Then Build
- Add schema tests: unique, not_null, accepted_values, relationships
- Write singular test: `assert_review_count_not_declining.sql`
- Add `packages.yml` with `dbt_utils`, `dbt_expectations`
- Add source freshness checks
- Run `dbt test` → all green

---

## Day 4 — Documentation + dbt-expectations

### Videos to Watch (~35 min)
| # | Video Title | Section | Duration |
|---|------------|---------|----------|
| 1 | Documentation Overview | Section 10 | 2 min |
| 2 | Writing and Exploring Basic Documentation | Section 10 | 8 min |
| 3 | Markdown-based Docs, Custom Overview Page and Assets | Section 10 | 9 min |
| 4 | The Linage Graph (Data Flow DAG) | Section 10 | 6 min |
| 5 | Great Expectations Overview | Section 13 | 14 min |
| | **Total** | | **~39 min** (watch at 1.25x = ~31 min) |

### Optional Reading (O'Reilly)
- "Data Engineering with dbt" Ch. 7: Documentation as code — auto-generated docs, column descriptions
- dbt best practices: https://docs.getdbt.com/best-practices/how-we-structure/1-guide-overview

### Then Build
- Add `description` to every model and column in YAML
- Generate docs: `dbt docs generate`
- Deploy docs to S3 static website (Terraform)
- Add `dbt_expectations` tests (column value ranges, distribution checks)

---

## Day 5 — Snapshots + Jinja/Macros + Variables

### Videos to Watch (~34 min)
| # | Video Title | Section | Duration |
|---|------------|---------|----------|
| 1 | Snapshots Overview | Section 6 | 3 min |
| 2 | Create a Snapshot | Section 6 | 12 min |
| 3 | Jinja Basics | Section 9 | 2 min |
| 4 | Let's take Jinja for a Drive | Section 9 | 1 min |
| 5 | dbt-Specific Jinja Features | Section 9 | 3 min |
| 6 | Create Your Own Macros | Section 9 | 2 min |
| 7 | Advanced Macros in Action | Section 9 | 4 min |
| 8 | Working with dbt Variables | Section 18 | 4 min |
| 9 | Using Date Ranges to Make Incremental Models Production-Ready | Section 18 | 5 min |
| | **Total** | | **~36 min** (watch at 1.25x = ~29 min) |

### Optional Reading (O'Reilly)
- "Data Engineering with dbt" Ch. 6: Advanced dbt — Jinja templating, macros, DRY patterns
- "The Data Warehouse Toolkit" (Kimball) Ch. 2: Slowly Changing Dimensions (theory behind snapshots)

### Then Build
- Create snapshot for tracking review changes
- Write custom macros for common patterns
- Use variables to make incremental models production-ready

---

## Day 6 — CI/CD + Production Patterns + Push

### Videos to Watch (~30 min)
| # | Video Title | Section | Duration |
|---|------------|---------|----------|
| 1 | Slim CI Introduction and Learning Objectives | Section 21 | 1 min |
| 2 | Working with Multiple Targets | Section 21 | 3 min |
| 3 | Custom Schemas: Separating Production and Development Environments | Section 21 | 4 min |
| 4 | Comparing Production and Development State | Section 21 | 5 min |
| 5 | Slim CI Workflow Overview | Section 22 | 4 min |
| 6 | Integration and Deployment Using Github Actions | Section 22 | 3 min |
| 7 | Production Pipelines and Artifacts | Section 22 | 5 min |
| 8 | Creating and Testing Feature Branches and Integrating to Production | Section 22 | 7 min |
| | **Total** | | **~32 min** |

### Optional Reading (O'Reilly)
- "Data Engineering with dbt" Ch. 9: CI/CD for dbt — testing in CI, deployment strategies
- Article: dbt best practices guide (docs.getdbt.com/best-practices)

### Then Build
- GitHub Actions: `dbt build` on PR, deploy docs on merge
- Add sqlfluff linting step
- Configure custom schema macro (dev vs prod)
- Final commit and push to `dbt-ecommerce-warehouse` repo

---

## Sections to SKIP entirely

| Section | Reason | Time Saved |
|---------|--------|------------|
| Snowflake Registration + Setup (Section 2 partials) | Using Redshift | ~30 min |
| Section 12: dbt Hero | Community/meta | 2 min |
| Section 17: Python Models | Spark handles our Python transforms | 13 min |
| Section 23: dbt Fusion | Too new, not stable for production | 33 min |
| Section 24: Orchestrating dbt with Dagster | Using Step Functions (Sprint 16) | 1 hr |
| Section 25: Capstone Project | Building our own ShopStream project | 2 min |
| Section 26: Power User VSCode Extension | Nice-to-have, not essential | 1 hr 21 min |

---

## Bonus: Watch Later (after Sprint 3, for deeper understanding)

These are useful but not needed for Sprint 3's build. Watch them when revisiting dbt in Sprint 15 (Advanced dbt):

| Video Title | Section | Duration | Why Useful Later |
|-------------|---------|----------|-----------------|
| Hooks | Section 11 | 6 min | Sprint 15: pre/post hooks for grants, logging |
| Exposures | Section 11 | 4 min | Sprint 15: connecting dbt to BI tools |
| Microbatching | Section 19 | 7 min | Sprint 15: incremental strategies |
| Model Versioning | Section 20 | 6 min | Sprint 15: model lifecycle management |
| Tags | Section 16 | 3 min | Sprint 15: selective runs |
| Model Selection Deep Dive | Section 16 | 8 min | Sprint 15: `--select state:modified+` |
| A Case Study - How Bitrise manages 1200+ models | Section 21 | 25 min | Sprint 15: scaling dbt |

---

## Optional Deep-Dive Reading (O'Reilly)

| Topic | Resource | When It's Useful |
|-------|----------|-----------------|
| dbt project structure | "Data Engineering with dbt" Ch. 4 | Before Day 1 |
| Dimensional modeling | "The Data Warehouse Toolkit" Ch. 1-3 | Sprint 15 context |
| Incremental strategies deep dive | "Data Engineering with dbt" Ch. 3 | Before Day 2 |
| Data quality dimensions | "Data Quality Fundamentals" Ch. 1-3 | Sprint 12 context |
| SQL style guide | SQLFluff docs | Before Day 6 |
| dbt + Redshift specifics | dbt-redshift adapter docs | Before Day 1 |
