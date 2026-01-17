# iOS-Style Theme Guide

## Color Palette

### Primary Colors
- **Primary Blue**: `#007AFF` - iOS signature blue, used for primary actions and accents
- **Secondary Light Blue**: `#5AC8FA` - iOS light blue, used for gradients and secondary elements
- **Accent Orange**: `#FF9500` - iOS orange, used for highlights and tertiary actions

### Background Colors
- **Background**: `#F2F2F7` - iOS light background (gray/white)
- **Card/Surface**: `#FFFFFF` - Pure white for cards and elevated surfaces
- **Surface Alt**: `#FAFAFA` - Very light gray for subtle surfaces

### Text Colors
- **Primary Text**: `#1C1C1E` - Dark gray, almost black
- **Secondary Text**: `#3C3C43` - Medium gray
- **Tertiary Text**: `#8E8E93` - Light gray for subtle text
- **Divider**: `#E5E5EA` - iOS standard divider color

## Typography

### Geometric Font Family
Uses the 'Geometria' font family throughout with iOS-standard weights and sizes:

- **Headline Large**: 34px, Bold (700) - For major section titles
- **Headline Medium**: 28px, Semibold (600) - For screen titles
- **Title Large**: 22px, Semibold (600) - For prominent titles
- **Title Medium**: 17px, Semibold (600) - For card titles
- **Body Large**: 17px, Regular (400) - For primary body text
- **Body Medium**: 15px, Regular (400) - For secondary body text
- **Body Small**: 13px, Regular (400) - For captions and labels
- **Label Large**: 15px, Medium (500) - For buttons and interactive elements

## Components

### Cards
- **Elevation**: 0 (flat design)
- **Border Radius**: 12px
- **Background**: White (#FFFFFF)
- **Shadow**: Subtle black shadow at 5% opacity with 10px blur

### Buttons
- **Border Radius**: 12px
- **Padding**: 20px horizontal, 14px vertical
- **Elevation**: 0
- **Font**: 17px, Semibold (600)
- **Primary**: iOS Blue background with white text

### Bottom Navigation
- **Container**: White background with subtle top shadow
- **Tab Indicator**: iOS Blue with rounded corners
- **Selected Tab**: White text on blue background
- **Unselected Tab**: 60% opacity gray text
- **Account Button**: Full-width iOS Blue button

### Gradients
- **Primary Gradient**: iOS Blue → Light Blue (top-left to bottom-right)
- **Shadow**: Matching color shadow at 20% opacity with 12px blur and 4px offset

### Pills/Chips
- **Background**: Light gray (#F2F2F7)
- **Border Radius**: 12px
- **Icon Color**: iOS Blue
- **Text Color**: Dark gray (#1C1C1E)
- **Padding**: 12px horizontal, 8-10px vertical

## Design Principles

1. **Clean & Minimal**: Embrace negative space, avoid clutter
2. **Subtle Shadows**: Use soft, barely visible shadows for depth
3. **High Contrast**: Ensure text is easily readable with proper color contrast
4. **Rounded Corners**: Consistent 12-16px radius for modern iOS look
5. **White Cards**: Use pure white cards on light gray background
6. **Blue Accents**: Primary actions and interactive elements use iOS Blue
7. **Flat Design**: Minimal elevation, rely on shadows and borders for depth

## Platform Optimization

### iPhone Specific
- Safe area padding for notched devices
- Large touch targets (44x44 minimum)
- System font weights and sizes
- Native iOS color palette
- Smooth animations and transitions

### Accessibility
- High contrast text colors
- Minimum 13px font size
- Clear visual hierarchy
- Sufficient touch target spacing
- Color-independent information

## Usage Examples

### Feature Cards
```dart
Container(
  padding: EdgeInsets.all(20),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: 10,
        offset: Offset(0, 2),
      ),
    ],
  ),
  child: ...,
)
```

### Gradient Hero Cards
```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFF007AFF), Color(0xFF5AC8FA)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Color(0xFF007AFF).withOpacity(0.2),
        blurRadius: 12,
        offset: Offset(0, 4),
      ),
    ],
  ),
  child: ...,
)
```

### Info Pills
```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  decoration: BoxDecoration(
    color: Color(0xFFF2F2F7),
    borderRadius: BorderRadius.circular(12),
  ),
  child: Row(
    children: [
      Icon(icon, size: 18, color: Color(0xFF007AFF)),
      SizedBox(width: 6),
      Text(label, style: TextStyle(color: Color(0xFF1C1C1E))),
    ],
  ),
)
```

## Testing on iPhone
- Recommended: Test on iPhone 12, 13, 14, or 15 models
- Verify safe area insets on notched devices
- Check touch target sizes on smaller devices (SE)
- Test in both portrait and landscape orientations
- Validate color accuracy on different displays
