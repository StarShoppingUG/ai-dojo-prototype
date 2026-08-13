"use client";

import { useEffect, useState } from "react";
import Link from "next/link";

export default function Navbar() {
  const [isDark, setIsDark] = useState(false);

  // Read theme choices on initial load
  useEffect(() => {
    const isDarkTheme = 
      document.documentElement.classList.contains("dark") || 
      localStorage.getItem("theme") === "dark" ||
      (!("theme" in localStorage) && window.matchMedia("(prefers-color-scheme: dark)").matches);
    
    if (isDarkTheme) {
      document.documentElement.classList.add("dark");
      setIsDark(true);
    } else {
      document.documentElement.classList.remove("dark");
      setIsDark(false);
    }
  }, []);

  // Handle active clicks to toggle the theme class
  const toggleTheme = () => {
    if (document.documentElement.classList.contains("dark")) {
      document.documentElement.classList.remove("dark");
      localStorage.setItem("theme", "light");
      setIsDark(false);
    } else {
      document.documentElement.classList.add("dark");
      localStorage.setItem("theme", "dark");
      setIsDark(true);
    }
  };

 return (
  <header className="sticky top-0 left-0 right-0 z-50 bg-white/10 dark:bg-zinc-900/10 backdrop-blur-sm border-b border-line dark:border-zinc-800 py-3 transition-colors duration-200">
    <div className="max-w-[960px] mx-auto px-6 flex items-center justify-between">
        
        {/* CHANGED: Wrapped Link in a relative group container to attach a premium tooltip */}
        <div className="relative group">
          <Link href="/" className="flex items-baseline gap-3 no-underline">
            <span className="font-display text-[28px] font-bold text-ai-indigo-deep dark:text-indigo-400 tracking-[0.02em]">
              AI DOJO
            </span>
            <span className="text-[13px] text-ink-soft dark:text-zinc-400 tracking-[0.06em]">
              日本語ロールプレイ練習
            </span>
          </Link>
          
          {/* Logo Hover Info Box */}
          <div className="absolute top-full left-0 mt-2 pointer-events-none opacity-0 group-hover:opacity-100 transition-opacity duration-150 z-50 bg-zinc-900/90 dark:bg-zinc-100/90 text-zinc-50 dark:text-zinc-900 text-xs font-medium px-2.5 py-1 rounded shadow-md whitespace-nowrap">
            Go to Homepage
          </div>
        </div>

        {/* CHANGED: Wrapped Button in a relative group container to append an aligned tooltip */}
        <div className="relative group flex items-center">
          {/* Theme Button Hover Info Box */}
          <div className="absolute top-full right-0 mt-2 pointer-events-none opacity-0 group-hover:opacity-100 transition-opacity duration-150 z-50 bg-zinc-900/90 dark:bg-zinc-100/90 text-zinc-50 dark:text-zinc-900 text-xs font-medium px-2.5 py-1 rounded shadow-md whitespace-nowrap">
            Switch to {isDark ? "Light" : "Dark"} Mode
          </div>

          <button
            onClick={toggleTheme}
            aria-label="Toggle dark mode"
            className="flex h-9 w-9 items-center justify-center rounded-full bg-zinc-100 hover:bg-zinc-200 dark:bg-zinc-800 dark:hover:bg-zinc-700 text-zinc-700 dark:text-zinc-200 transition-all duration-200 active:scale-90 border border-zinc-200 dark:border-zinc-700 shadow-sm cursor-pointer"
          >
            {isDark ? (
              /* Sun Icon (Renders when dark mode is currently active) */
              <svg className="h-4 w-4 fill-none stroke-current stroke-[2]" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" d="M12 3v2m0 14v2m9-9h-2M5 12H3m15.364-6.364l-1.414 1.414M7.05 16.95l-1.414 1.414M18.364 18.364l-1.414-1.414M7.05 7.05L5.636 5.636M12 8a4 4 0 100 8 4 4 0 000-8z" />
              </svg>
            ) : (
              /* Moon Icon (Renders when light mode is currently active) */
              <svg className="h-4 w-4 fill-none stroke-current stroke-[2]" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" d="M21.752 15.002A9.718 9.718 0 0118 15.75c-5.385 0-9.75-4.365-9.75-9.75 0-1.33.266-2.597.748-3.752A9.753 9.753 0 003 11.25C3 16.635 7.365 21 12.75 21a9.753 9.753 0 009.002-5.998z" />
              </svg>
            )}
          </button>
        </div>

      </div>
    </header>
  );
}
