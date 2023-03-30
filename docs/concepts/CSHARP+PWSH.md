# The relationship between PowerShell and C#

The founding concept behind this repository is the fact that PowerShell and C# share MicroSoft's Common Language Runtime (CLR).

The CLR is the runtime interpreter for *both* languages. Which means that both Languages also share the same type system. And that means that things you can do in one, you could theoretically do in the other.

## The catch

There's just one major catch. While PowerShell does inherit C#'s type system, it doesn't inherit some of the niceties that come with it, like application lifetimes.

C# is loop-oriented. Meaning that it's scripts, aren't scripts, and are programs running on a MOL or Main-Operating-Loop

PowerShell does have a loop, but it's loop is the REPL or Read-Evaluate-Print-Loop. Which means that PowerShell's scripts are executed linearly, and are only called on a loop *if you specify it.*

## The solution

The solution is to call the "niceties" that C# has manually. These "niceties" include things like the `Application.Run()` function call (called automatically upon `Application` creation in C#, but not in pwsh).

## The real problem

So, you might ask, if PowerShell can do all of the things that C# can, why has nobody successfully implemented C# apps in PowerShell. Well, they have. A particularly good example is the PSAvalonia library from which a lot of this source code is based on. If you try to run an app using PSAvalonia, you may notice that calling their cmdlets causes PowerShell to hang.

This is because PSAvalonia calls `Application.Run()` which is unfortunately a Synchronous function call that starts the Application's MOL. WPF's and WinForm's `Application.Run()` functions also suffer the same problem (though WPF and WinForms already have some limited asynchronous support in PowerShell)

## The real problem's solution

So, what's the solution? Running a .NET MOL synchronously in PowerShell defeats the purpose of running it in PowerShell, and *that purpose is app automation.*

So, the solution is to multithread.

Since the second intention of this repository is to provide a way to run .NET apps in pure PowerShell, I've decided to go with PowerShell runspaces for making this work.

This library provides the `Initialize-AsyncRuntime` cmdlet, which creates a new runspace, and runs the `Application.Run()` function call in that runspace. It also does other things and is convered in [its own documentation](../api/INITIALIZE-RUNTIME.md).