package arrays;

class DynamicArray {
    private int[] data;
    private int size;
    private int capacity;

    public DynamicArray() {
        capacity = 4;              // start small
        data = new int[capacity];
        size = 0;
    }

    public void add(int element) {
        if (size == capacity) {    // FULL → must resize
            resize();              // O(n) but happens rarely
        }
        data[size] = element;      // O(1) write
        size++;                    // O(1) increment
    }

    private void resize() {
        capacity = capacity * 2;   // DOUBLE the capacity
        int[] newData = new int[capacity];
        for (int i = 0; i < size; i++) {   // copy all: O(n)
            newData[i] = data[i];
        }
        data = newData;            // point to new array
    }
    public int get(int index) {
        if (index < 0 || index >= size) throw new IndexOutOfBoundsException();
        return data[index];        // O(1) direct access
    }
}