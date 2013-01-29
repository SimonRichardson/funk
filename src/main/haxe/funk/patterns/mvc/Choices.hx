package funk.patterns.mvc;

enum Choices<T, K> {
    Add(value : T);
    AddAt(value : T, key : K);
    Get;
    GetAt(key : K);
    Remove(value : T);
    RemoveAt(key : K);
    Sync;
    Update(oldValue : T, newValue : T);
    UpdateAt(value : T, key : K);
}
