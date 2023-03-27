# Declarative-programming-homework
Exact details on each homeworks are found on the subject website(https://dp.iit.bme.hu/dp22a/)

# Background

The task is to create a matrix that describes the positions of the tents in a rectangular camping site that is divided into square, equally sized parcels. The camping site forms an n x m matrix (n * m > 1). Initially, most of the parcels are empty, while some have trees on them. We can set up tents on empty parcels, connected to adjacent trees. The following conditions apply:

* Each parcel can have at most one tree or one tent.
* Each tree must be connected to exactly one tent, and each tent must be connected to exactly one tree.
* A tent can be connected to a tree only if the parcels they are on are adjacent.
* Parcels with tents on them cannot have any adjacent parcels with tents on them, neither diagonally nor orthogonally.
* Each parcel can have 1-4 adjacent parcels. If n=1 or m=1, the parcels at the beginning and end of each row or column have only one adjacent parcel, otherwise they have two. In general, parcels in the corners have two adjacent parcels, those on the edges have three, and those in the middle have four.

The position of a tree is given by its row and column indices in the matrix, and the position of a tent relative to its tree (north, east, south, west) must also be specified.

The task is to create a matrix of n rows and m columns that contains only 0 and 1 values, where an element is 1 if there is a tent on the corresponding parcel specified by its row and column index.
