public final class IntBox {
    private final int value;

    public IntBox(int value) {
        this.value = value;
    }

    public IntBox plus(IntBox other) {
        return new IntBox(value + other.value);
    }
    
    @Override
    public String toString() {
        return ""+value;
    }
}
