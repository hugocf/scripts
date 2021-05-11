# Kotlin Info

*(most recent on top)*

[TOC]

## Data class with a missing field in certain contexts

-  [Nothing? can save us · What I should have said](http://oneeyedmen.com/nothing-can-save-us.html) 

*… base structure*

```kotlin
data class CustomerData<out T : String?>(
    val id: T,
    val name: String,
)
```

*… generalisation*

```kotlin
typealias AnyCustomer = CustomerData<*>
val AnyCustomer.isSaved get() = id != null
```

*… specialisation*

```kotlin
typealias SavedCustomer = CustomerData<String>
typealias UnsavedCustomer = CustomerData<Nothing?>
```

*… conversion*

```kotlin
@Suppress("UNCHECKED_CAST")
fun UnsavedCustomer.saved(id: String) = (this as SavedCustomer).copy(id)
```

*… usage*

```kotlin
// Ok
val saved = SavedCustomer("123", "Name")
val unsaved = UnsavedCustomer(null, "Fred")

// Type mismatch
val err1 = SavedCustomer(null, "name")    // Null can not be a value of a non-null type String
val err2 = UnsavedCustomer("123", "Name") // inferred type is String but Nothing? was expected
val err3: String = unsaved.id     // inferred type is Nothing? but String was expected
val err4: SavedCustomer = unsaved // inferred type is UnsavedCustomer but SavedCustomer was expected
val err5: UnsavedCustomer = saved // inferred type is SavedCustomer but UnsavedCustomer was expected
```



---

