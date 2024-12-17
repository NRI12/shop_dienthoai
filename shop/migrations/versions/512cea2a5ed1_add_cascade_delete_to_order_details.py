"""Add cascade delete to order details

Revision ID: 512cea2a5ed1
Revises: 03034c138132
Create Date: 2024-07-08 09:51:12.216316

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import mysql

# revision identifiers, used by Alembic.
revision = '512cea2a5ed1'
down_revision = '03034c138132'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    with op.batch_alter_table('orders', schema=None) as batch_op:
        batch_op.alter_column('total',
               existing_type=mysql.DECIMAL(precision=20, scale=2),
               type_=sa.Numeric(precision=10, scale=2),
               nullable=False)

    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    with op.batch_alter_table('orders', schema=None) as batch_op:
        batch_op.alter_column('total',
               existing_type=sa.Numeric(precision=10, scale=2),
               type_=mysql.DECIMAL(precision=20, scale=2),
               nullable=True)

    # ### end Alembic commands ###
