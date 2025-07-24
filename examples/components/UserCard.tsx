// React Component Pattern Beispiel

import React, { useState, useCallback, useMemo } from 'react';
import { User } from '../../types/User';
import { Button } from '../ui/Button';
import { Card } from '../ui/Card';
import { cn } from '../../utils/cn';

interface UserCardProps {
  user: User;
  onEdit?: (user: User) => void;
  onDelete?: (userId: string) => void;
  onViewProfile?: (userId: string) => void;
  className?: string;
  showActions?: boolean;
  variant?: 'default' | 'compact' | 'detailed';
}

/**
 * UserCard Component
 * 
 * Zeigt Benutzer-Informationen in einer Karte an.
 * Unterstützt verschiedene Varianten und optionale Aktionen.
 * 
 * @example
 * ```tsx
 * <UserCard 
 *   user={user} 
 *   onEdit={handleEdit}
 *   onDelete={handleDelete}
 *   variant="detailed"
 * />
 * ```
 */
export const UserCard: React.FC<UserCardProps> = ({
  user,
  onEdit,
  onDelete,
  onViewProfile,
  className,
  showActions = true,
  variant = 'default'
}) => {
  const [isDeleting, setIsDeleting] = useState(false);

  // Memoized computed values
  const initials = useMemo(() => {
    return user.name
      .split(' ')
      .map(part => part.charAt(0))
      .join('')
      .toUpperCase();
  }, [user.name]);

  const formattedDate = useMemo(() => {
    return new Intl.DateTimeFormat('de-DE', {
      year: 'numeric',
      month: 'short',
      day: 'numeric'
    }).format(new Date(user.createdAt));
  }, [user.createdAt]);

  // Event handlers
  const handleEdit = useCallback(() => {
    onEdit?.(user);
  }, [user, onEdit]);

  const handleDelete = useCallback(async () => {
    if (!onDelete) return;
    
    setIsDeleting(true);
    try {
      await onDelete(user.id);
    } finally {
      setIsDeleting(false);
    }
  }, [user.id, onDelete]);

  const handleViewProfile = useCallback(() => {
    onViewProfile?.(user.id);
  }, [user.id, onViewProfile]);

  const cardClasses = cn(
    'user-card',
    'border rounded-lg p-4 bg-white shadow-sm hover:shadow-md transition-shadow',
    {
      'user-card--compact': variant === 'compact',
      'user-card--detailed': variant === 'detailed',
    },
    className
  );

  const renderAvatar = () => (
    <div className="user-card__avatar">
      {user.avatar ? (
        <img
          src={user.avatar}
          alt={`${user.name} Avatar`}
          className="w-12 h-12 rounded-full object-cover"
        />
      ) : (
        <div className="w-12 h-12 rounded-full bg-gray-200 flex items-center justify-center text-gray-600 font-medium">
          {initials}
        </div>
      )}
    </div>
  );

  const renderUserInfo = () => (
    <div className="user-card__info flex-1 ml-3">
      <h3 className="user-card__name text-lg font-semibold text-gray-900">
        {user.name}
      </h3>
      <p className="user-card__email text-gray-600 text-sm">
        {user.email}
      </p>
      
      {variant === 'detailed' && (
        <div className="user-card__meta mt-2 text-xs text-gray-500">
          <span>Mitglied seit {formattedDate}</span>
          {user.role && (
            <>
              <span className="mx-2">•</span>
              <span className="capitalize">{user.role}</span>
            </>
          )}
        </div>
      )}
    </div>
  );

  const renderActions = () => {
    if (!showActions) return null;

    return (
      <div className="user-card__actions flex space-x-2">
        {onViewProfile && (
          <Button
            variant="ghost"
            size="sm"
            onClick={handleViewProfile}
            aria-label={`Profil von ${user.name} anzeigen`}
          >
            Profil
          </Button>
        )}
        
        {onEdit && (
          <Button
            variant="outline"
            size="sm"
            onClick={handleEdit}
            aria-label={`${user.name} bearbeiten`}
          >
            Bearbeiten
          </Button>
        )}
        
        {onDelete && (
          <Button
            variant="destructive"
            size="sm"
            onClick={handleDelete}
            disabled={isDeleting}
            aria-label={`${user.name} löschen`}
          >
            {isDeleting ? 'Lösche...' : 'Löschen'}
          </Button>
        )}
      </div>
    );
  };

  if (variant === 'compact') {
    return (
      <div className={cardClasses}>
        <div className="flex items-center">
          {renderAvatar()}
          {renderUserInfo()}
          {renderActions()}
        </div>
      </div>
    );
  }

  return (
    <Card className={cardClasses}>
      <div className="user-card__header flex items-start">
        {renderAvatar()}
        {renderUserInfo()}
      </div>
      
      {variant === 'detailed' && user.bio && (
        <div className="user-card__bio mt-3 text-gray-700 text-sm">
          {user.bio}
        </div>
      )}
      
      {showActions && (
        <div className="user-card__footer mt-4 pt-3 border-t border-gray-100">
          {renderActions()}
        </div>
      )}
    </Card>
  );
};

// Export für Tests
export type { UserCardProps };
