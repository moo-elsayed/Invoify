# Project Coding Guidelines & Best Practices

## State Management & Rebuild Optimization
- **Minimize `setState`**: Use `setState` only when absolutely necessary and scoped to the narrowest possible widget tree to prevent unnecessary widget rebuilds.
- **Prefer `ValueNotifier` & `ValueListenableBuilder`**: For simple reactive UI states within widgets, use `ValueNotifier` / `ValueListenableBuilder` instead of triggering full-widget `setState`.

## Component Architecture & Modularization
- **No Helper Build Functions**: Avoid creating private helper methods that return widgets (e.g. `_buildHeader()`, `_buildCard()`).
- **Separate Custom Widgets**: Always split UI sections into dedicated, reusable custom widget classes (`StatelessWidget` or `StatefulWidget`) placed in their own separate files.

## Form & Keyboard Interactions
- **Keyboard Unfocus**: Always wrap screens, cards, or forms containing text input fields with `CustomKeyboardUnfocus` widget so the user can easily dismiss the keyboard by tapping outside.

## Performance Best Practices
- Always enforce performance best practices (e.g., using `const` constructors where possible, avoiding heavy work inside `build` methods, optimizing list view builders and animations).
