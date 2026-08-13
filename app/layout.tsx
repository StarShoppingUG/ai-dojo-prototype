import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Japanese Roleplay Prototype",
  description: "Practice real-world Japanese conversations with an AI roleplay partner.",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body className="min-h-dvh flex flex-col bg-paper text-ink transition-colors duration-200">
        {children}
      </body>
    </html>
  );
}
