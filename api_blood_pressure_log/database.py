# BoilerPlate code #
import databases
import sqlalchemy


from config import config

metadata = sqlalchemy.MetaData()
# BoilerPlate code #

user_table = sqlalchemy.Table(
    "users",
    metadata,
    sqlalchemy.Column("id", sqlalchemy.Integer, primary_key=True),
    sqlalchemy.Column("email", sqlalchemy.String, unique=True),
    sqlalchemy.Column("password", sqlalchemy.String),
    sqlalchemy.Column("fcm_token", sqlalchemy.String),
    sqlalchemy.Column("verification_code", sqlalchemy.String, default=None),
    sqlalchemy.Column("confirmed", sqlalchemy.Boolean, default=False),
)


bpm_record = sqlalchemy.Table(
    "record",
    metadata,
    sqlalchemy.Column("id", sqlalchemy.Integer, primary_key=True),
    sqlalchemy.Column("systolic_value", sqlalchemy.Integer),
    sqlalchemy.Column("diastolic_value", sqlalchemy.Integer),
    sqlalchemy.Column("log_date", sqlalchemy.DateTime),
    sqlalchemy.Column("image_url", sqlalchemy.String),
    sqlalchemy.Column("user_id", sqlalchemy.ForeignKey("users.id"), nullable=False),
)

# BoilerPlate code #
connect_args = {"check_same_thread": False} if "sqlite" in config.DATABASE_URL else {}
engine = sqlalchemy.create_engine(
    config.DATABASE_URL, connect_args=connect_args
)

db_args = {"min_size":1, "max_size":3} if "postgres" in config.DATABASE_URL else {}

metadata.create_all(engine)
database = databases.Database(
    config.DATABASE_URL, force_rollback=config.DB_FORCE_ROLL_BACK, **db_args
)
# BoilerPlate code #