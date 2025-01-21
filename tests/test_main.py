# tests/test_main.py

import unittest
from huey.main import main

class TestMain(unittest.TestCase):
    def test_main_runs(self):
        # Test that main() runs without errors
        try:
            main()
            self.assertTrue(True)
        except Exception as e:
            self.fail(f"The main function raised an exception: {e}")

if __name__ == '__main__':
    unittest.main()
