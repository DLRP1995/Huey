# setup.py
from setuptools import setup, find_packages

setup(
    name='huey',
    version='0.1.0',
    packages=find_packages(),
    install_requires=[
        # Dependencies listed here
    ],
    entry_points={
        'console_scripts': [
            'huey=huey.main:main',
        ],
    },
)
