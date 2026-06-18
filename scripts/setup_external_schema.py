import os
import psycopg2

REDSHIFT_HOST = os.environ.get("REDSHIFT_HOST", "shopstream-dev-wg.617541206239.us-east-1.redshift-serverless.amazonaws.com")
REDSHIFT_PORT = int(os.environ.get("REDSHIFT_PORT", 5439))
REDSHIFT_DB = os.environ.get("REDSHIFT_DB", "shopstream")
REDSHIFT_USER = os.environ.get("REDSHIFT_USER", "admin")
REDSHIFT_PASSWORD = os.environ["TF_VAR_redshift_admin_password"]
COPY_ROLE_ARN = os.environ["COPY_ROLE_ARN"]

conn = psycopg2.connect(
    host=REDSHIFT_HOST,
    port=REDSHIFT_PORT,
    dbname=REDSHIFT_DB,
    user=REDSHIFT_USER,
    password=REDSHIFT_PASSWORD,
)
conn.autocommit = True
cur = conn.cursor()

print("Creating raw_data schema...")
cur.execute("CREATE SCHEMA IF NOT EXISTS raw_data")

# --- PART (Products) ---
print("\nCreating part table (products)...")
cur.execute("DROP TABLE IF EXISTS raw_data.part")
cur.execute("""
    CREATE TABLE raw_data.part (
        p_partkey     INTEGER NOT NULL,
        p_name        VARCHAR(22) NOT NULL,
        p_mfgr        VARCHAR(6) NOT NULL,
        p_category    VARCHAR(7) NOT NULL,
        p_brand1      VARCHAR(9) NOT NULL,
        p_color       VARCHAR(11) NOT NULL,
        p_type        VARCHAR(25) NOT NULL,
        p_size        INTEGER NOT NULL,
        p_container   VARCHAR(10) NOT NULL
    )
""")
print("Loading part from S3...")
cur.execute(f"""
    COPY raw_data.part
    FROM 's3://awssampledbuswest2/ssbgz/part'
    IAM_ROLE '{COPY_ROLE_ARN}'
    GZIP
    DELIMITER '|'
    REGION 'us-west-2'
""")
cur.execute("SELECT COUNT(*) FROM raw_data.part")
print(f"  Loaded: {cur.fetchone()[0]:,} products")

# --- CUSTOMER ---
print("\nCreating customer table...")
cur.execute("DROP TABLE IF EXISTS raw_data.customer")
cur.execute("""
    CREATE TABLE raw_data.customer (
        c_custkey     INTEGER NOT NULL,
        c_name        VARCHAR(25) NOT NULL,
        c_address     VARCHAR(25) NOT NULL,
        c_city        VARCHAR(10) NOT NULL,
        c_nation      VARCHAR(15) NOT NULL,
        c_region      VARCHAR(12) NOT NULL,
        c_phone       VARCHAR(15) NOT NULL,
        c_mktsegment  VARCHAR(10) NOT NULL
    )
""")
print("Loading customer from S3...")
cur.execute(f"""
    COPY raw_data.customer
    FROM 's3://awssampledbuswest2/ssbgz/customer'
    IAM_ROLE '{COPY_ROLE_ARN}'
    GZIP
    DELIMITER '|'
    REGION 'us-west-2'
""")
cur.execute("SELECT COUNT(*) FROM raw_data.customer")
print(f"  Loaded: {cur.fetchone()[0]:,} customers")

# --- SUPPLIER ---
print("\nCreating supplier table...")
cur.execute("DROP TABLE IF EXISTS raw_data.supplier")
cur.execute("""
    CREATE TABLE raw_data.supplier (
        s_suppkey   INTEGER NOT NULL,
        s_name      VARCHAR(25) NOT NULL,
        s_address   VARCHAR(25) NOT NULL,
        s_city      VARCHAR(10) NOT NULL,
        s_nation    VARCHAR(15) NOT NULL,
        s_region    VARCHAR(12) NOT NULL,
        s_phone     VARCHAR(15) NOT NULL
    )
""")
print("Loading supplier from S3...")
cur.execute(f"""
    COPY raw_data.supplier
    FROM 's3://awssampledbuswest2/ssbgz/supplier'
    IAM_ROLE '{COPY_ROLE_ARN}'
    GZIP
    DELIMITER '|'
    REGION 'us-west-2'
""")
cur.execute("SELECT COUNT(*) FROM raw_data.supplier")
print(f"  Loaded: {cur.fetchone()[0]:,} suppliers")

# --- DWDATE (Date Dimension) ---
print("\nCreating dwdate table...")
cur.execute("DROP TABLE IF EXISTS raw_data.dwdate")
cur.execute("""
    CREATE TABLE raw_data.dwdate (
        d_datekey          INTEGER NOT NULL,
        d_date             VARCHAR(19) NOT NULL,
        d_dayofweek        VARCHAR(10) NOT NULL,
        d_month            VARCHAR(10) NOT NULL,
        d_year             INTEGER NOT NULL,
        d_yearmonthnum     INTEGER NOT NULL,
        d_yearmonth        VARCHAR(8) NOT NULL,
        d_daynuminweek     INTEGER NOT NULL,
        d_daynuminmonth    INTEGER NOT NULL,
        d_daynuminyear     INTEGER NOT NULL,
        d_monthnuminyear   INTEGER NOT NULL,
        d_weeknuminyear    INTEGER NOT NULL,
        d_sellingseason    VARCHAR(13) NOT NULL,
        d_lastdayinweekfl  VARCHAR(1) NOT NULL,
        d_lastdayinmonthfl VARCHAR(1) NOT NULL,
        d_holidayfl        VARCHAR(1) NOT NULL,
        d_weekdayfl        VARCHAR(1) NOT NULL
    )
""")
print("Loading dwdate from S3...")
cur.execute(f"""
    COPY raw_data.dwdate
    FROM 's3://awssampledbuswest2/ssbgz/dwdate'
    IAM_ROLE '{COPY_ROLE_ARN}'
    GZIP
    DELIMITER '|'
    REGION 'us-west-2'
""")
cur.execute("SELECT COUNT(*) FROM raw_data.dwdate")
print(f"  Loaded: {cur.fetchone()[0]:,} dates")

# --- LINEORDER (Fact Table - Orders) ---
print("\nCreating lineorder table (this is the large fact table)...")
cur.execute("DROP TABLE IF EXISTS raw_data.lineorder")
cur.execute("""
    CREATE TABLE raw_data.lineorder (
        lo_orderkey        INTEGER NOT NULL,
        lo_linenumber      INTEGER NOT NULL,
        lo_custkey         INTEGER NOT NULL,
        lo_partkey         INTEGER NOT NULL,
        lo_suppkey         INTEGER NOT NULL,
        lo_orderdate       INTEGER NOT NULL,
        lo_orderpriority   VARCHAR(15) NOT NULL,
        lo_shippriority    VARCHAR(1) NOT NULL,
        lo_quantity        INTEGER NOT NULL,
        lo_extendedprice   INTEGER NOT NULL,
        lo_ordertotalprice INTEGER NOT NULL,
        lo_discount        INTEGER NOT NULL,
        lo_revenue         INTEGER NOT NULL,
        lo_supplycost      INTEGER NOT NULL,
        lo_tax             INTEGER NOT NULL,
        lo_commitdate      INTEGER NOT NULL,
        lo_shipmode        VARCHAR(10) NOT NULL
    )
""")
print("Loading lineorder from S3 (600M rows, may take 5-10 minutes)...")
cur.execute(f"""
    COPY raw_data.lineorder
    FROM 's3://awssampledbuswest2/ssbgz/lineorder'
    IAM_ROLE '{COPY_ROLE_ARN}'
    GZIP
    DELIMITER '|'
    REGION 'us-west-2'
""")
cur.execute("SELECT COUNT(*) FROM raw_data.lineorder")
print(f"  Loaded: {cur.fetchone()[0]:,} orders")

# --- SUMMARY ---
print("\n" + "=" * 50)
print("LOAD COMPLETE - Summary:")
print("=" * 50)
for table in ["part", "customer", "supplier", "dwdate", "lineorder"]:
    cur.execute(f"SELECT COUNT(*) FROM raw_data.{table}")
    print(f"  raw_data.{table}: {cur.fetchone()[0]:,} rows")

cur.close()
conn.close()
print("\nDone.")
