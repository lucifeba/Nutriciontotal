import { Card, CardContent } from "@/components/ui/card";
import { cn } from "@/lib/utils";
import { LucideIcon } from "lucide-react";

interface StatsCardProps {
  icon: LucideIcon;
  title: string;
  value: string | number;
  description?: string;
  trend?: {
    value: number;
    positive: boolean;
  };
  className?: string;
}

export function StatsCard({ icon: Icon, title, value, description, trend, className }: StatsCardProps) {
  return (
    <Card className={cn("hover:shadow-md transition-shadow", className)}>
      <CardContent className="p-6">
        <div className="flex items-start justify-between">
          <div className="space-y-2">
            <p className="text-sm text-muted-foreground">{title}</p>
            <p className="text-3xl font-bold text-[#2D5A3D]">{value}</p>
            {description && (
              <p className="text-xs text-muted-foreground">{description}</p>
            )}
            {trend && (
              <p
                className={cn(
                  "text-xs font-medium",
                  trend.positive ? "text-green-600" : "text-red-500"
                )}
              >
                {trend.positive ? "+" : "-"}{Math.abs(trend.value)}% vs. mes anterior
              </p>
            )}
          </div>
          <div className="p-3 rounded-lg bg-[#2D5A3D]/10">
            <Icon className="h-6 w-6 text-[#2D5A3D]" />
          </div>
        </div>
      </CardContent>
    </Card>
  );
}
