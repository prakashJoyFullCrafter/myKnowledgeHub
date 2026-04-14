package arrays;

public class MultiDimensionalArray {

    public static void main(String[] args) {
        // --- Declaration and Allocation ---
        int[][] matrix = new int[3][4];   // 3 rows, 4 columns
// All elements initialized to 0

// --- Inline Initialization ---
        int[][] grid = {
                {1, 2, 3},   // row 0
                {4, 5, 6},   // row 1
                {7, 8, 9}    // row 2
        };

// --- Access ---
        int val = grid[1][2];    // row 1, col 2 → val = 6

// --- Dimensions ---
        int rows = grid.length;       // 3
        int cols = grid[0].length;    // 3 (length of first row)

// --- Traversal (row-major order — ALWAYS prefer this for cache) ---
        for (int r = 0; r < rows; r++) {
            for (int c = 0; c < cols; c++) {
                System.out.print(grid[r][c] + " ");
            }
        }

// --- Jagged arrays (rows of different lengths) ---
        int[][] jagged = new int[3][];
        jagged[0] = new int[2];   // row 0 has 2 cols
        jagged[1] = new int[5];   // row 1 has 5 cols
        jagged[2] = new int[1];   // row 2 has 1 col
    }
}
