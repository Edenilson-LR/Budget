import React from 'react';
import { TouchableOpacity, Text, ActivityIndicator, StyleSheet, ViewStyle, TextStyle } from 'react-native';

export enum ButtonVariant {
  PRIMARY = 'primary',
  SECONDARY = 'secondary',
  DANGER = 'danger',
  GHOST = 'ghost',
}

interface CustomButtonProps {
  text: string;
  onPress?: () => void;
  variant?: ButtonVariant;
  icon?: React.ReactNode;
  isLoading?: boolean;
  isFullWidth?: boolean;
  disabled?: boolean;
}

export const CustomButton: React.FC<CustomButtonProps> = ({
  text,
  onPress,
  variant = ButtonVariant.PRIMARY,
  icon,
  isLoading = false,
  isFullWidth = false,
  disabled = false,
}) => {
  const getButtonStyle = (): ViewStyle => {
    const baseStyle: ViewStyle = {
      paddingHorizontal: 16,
      paddingVertical: 12,
      borderRadius: 12,
      alignItems: 'center',
      justifyContent: 'center',
      flexDirection: 'row',
      minHeight: 48,
    };

    if (isFullWidth) {
      baseStyle.width = '100%';
    }

    switch (variant) {
      case ButtonVariant.PRIMARY:
        return { ...baseStyle, backgroundColor: '#3B82F6' };
      case ButtonVariant.SECONDARY:
        return { ...baseStyle, backgroundColor: '#F3F4F6' };
      case ButtonVariant.DANGER:
        return { ...baseStyle, backgroundColor: '#FEE2E2' };
      case ButtonVariant.GHOST:
        return { ...baseStyle, backgroundColor: 'transparent' };
      default:
        return baseStyle;
    }
  };

  const getTextStyle = (): TextStyle => {
    const baseStyle: TextStyle = {
      fontSize: 14,
      fontWeight: '600',
    };

    switch (variant) {
      case ButtonVariant.PRIMARY:
        return { ...baseStyle, color: '#FFFFFF' };
      case ButtonVariant.SECONDARY:
        return { ...baseStyle, color: '#374151' };
      case ButtonVariant.DANGER:
        return { ...baseStyle, color: '#DC2626' };
      case ButtonVariant.GHOST:
        return { ...baseStyle, color: '#6B7280' };
      default:
        return baseStyle;
    }
  };

  return (
    <TouchableOpacity
      style={[getButtonStyle(), (isLoading || disabled) && styles.disabled]}
      onPress={onPress}
      disabled={isLoading || disabled}
      activeOpacity={0.7}
    >
      {isLoading ? (
        <ActivityIndicator size="small" color={getTextStyle().color} />
      ) : (
        <>
          {icon && <>{icon}</>}
          {icon && <Text style={{ width: 8 }} />}
          <Text style={getTextStyle()}>{text}</Text>
        </>
      )}
    </TouchableOpacity>
  );
};

const styles = StyleSheet.create({
  disabled: {
    opacity: 0.5,
  },
});

