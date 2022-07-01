############################################################
#
# Windows PowerShell in Action Chapter 3
# 
# 3.1 Type management in the wild, wild West
#
# 3.2 Basic types and literals
#
# 3.3 Collections: dictionaries and hash tables
#
# 3.4 Collections: arrays and sequences
#
# 3.5 Type literals
#
# 3.6 Type conversions
#
############################################################

# Many shell enviornments deal with strings - not much to learn - how
# to deal with special characters, passing things on to other
# systems/programs.  Lot's to struggle with turning this string into
# numbers, structured notions, etc.

# PowerShell deals with objects - everywhere, and objects are based
# on types.  Types have characteristics and behaviors and can do so much more.
# So, let's go learn about types

# 3.1 Type management in the wild, wild West

# Programming is about working with different types of objects.
# Question is how much does the system do on your behalf implicity when
# moving among domains.
# Domains? Host, Interactive Shell, other SubSystems, Functions, Language
#
# Typed languages - All
#    Statically Typed
#        Handles a lot for you
#        Must declare or make unambiguous through type inferencing
#    Dynamically Typed

# 3.1.1 PowerShell: a type-promiscuous language

#    Consisting of all sorts of things, not restricted
#    Will do a lot to take what you have and make it what you need
#    foo.Y - doesn't care what foo is as long as it has a property, Y.
#
# Approach
#    Reasonable conversions
#    No loss of information

 2 + 3.0 + "4"

 (2 + 3.0 + "4").GetType().FullName

 2 + "3.0" + 4
 (2 + "3.0" + 4).GetType().FullName

 (3+4)
 (3+4).GetType().FullName

 6 / 3
 (6 / 3).GetType().FullName

 6 / 4
 (6 / 4).GetType().FullName

 1e300

 1e300 + 12

 1e300 + 12d

 # 3.1.2 The Type System and type adaptation

 # .NET Type system inside at core
 #    .NET Type system slowly taking over

 # There are other type system in Microsoft ecosystem
 #    COM - Component Object Model
 #    WMI - Windows Management Instrumentation
 #    ADO - ActiveX Data Objects
 #    MOF - Managed Object Framework
 #    ADSI - Active Directory Services Interface
 #    XML - eXtensible Markup Language
 
 # PowerShell uses a type-adaptation system

 # PSObject - PSMemberInfo
 #    See CHR Notes - PowerShell - Types and Types - Basic and Literals

 # 3.2 Basic Types and Literals

 # 3.2.1 String Literals

 # 3.2.2 Numbers and numeric literals

# 3.3 Collections: dictionaries and hash tables

# 3.3.1 Creating and inspecting hash tables

# 3.3.2 Modifying and manipulating hash tables

# 3.3.3 Hash tables as reference types

# 3.4 Collections: arrays and sequences

# 3.4.1 Collecting pipeline output as an array

# 3.4.2 Array indexing

# 3.4.3 Polymorphism in arrays

# 3.4.4 Arrays as reference types

# 3.4.5 Singleton arrays and empty arrays

# 3.5 Type literals

# 3.5.1 Type name aliases

# 3.5.2 Generic type literals

# 3.5.3 Accessing static members with type literals

# 3.6 Type conversions

# 3.6.1 How type conversions work

# 3.6.2 PowerShell's type conversion algorithm

# 3.6.3 Special type conversions in parameter binding

# 3.7 Summary

