Concurrency Control in Advanced Database Applications

3 THE CONSISTENCY PROBLEM IN CONVENTIONAL DATABASE SYSTEMS
&&&
3 传统数据库系统的一致性问题
&&&
Database consistency is maintained if each data item in the database satisfies some
application-specific consistency constraints. For example, in a distributed airline reservation
system, one consistency constraint might be that each seat on a flight can be reserved by only
one passenger. It is often the case, however, that not all consistency constraints are known before
hand to the designers of general-purpose DBMSs, because of the lack of information about
the computations in potential applications.
&&&
如果数据库中每个数据项的一致性约束能够满足，那么我们称一致性能保证。例如，在一个分布式的航班预定系统中，一个一致性约束是，一个一致性的约束可能是每个座位只能被一个乘客预定一次。但是通常情况下，不是所有的一致性约束都可以在通用惯性系数据库设计者做的时候就能知道，因为失去了嵌套应用的一些信息。
&&&
Given the lack of knowledge about the application-specific semantics of database operations,
and the need to design general mechanisms that cut across many potential applications, the
best a DBMS can do is to abstract all operations on a database to be either a read operation or a
write operation, irrespective of the particular computation. Then it can guarantee that the
database is always in a consistent state with respect to reads and writes regardless of the semantics
of the particular application. Ignoring the possibility of bugs in the DBMS program and the
application program, inconsistent data then results from two main sources: (1) software or
hardware failures such as bugs in the operating system or a disk crash in the middle of operations,
and (2) concurrent access of the same data item by multiple users or programs.
&&&
我们知道了我们失去了应用特定的数据库操作的业务语义，然后要设计通用的机制来满足潜在的应用，数据库能做的就是抽象出所有数据库操作读操作或者写操作，不管具体的计算。然后就能保证数据库无论在具体系统的语义如何读操作和写操作总是能保持一致性。忽略数据库软件潜在的漏洞，不一致数据出现的可能原因为是：(1)软件或硬件的错误例如操作系统错误或者磁盘在操作的中间宕机，和(2)多用户多程序的对数据的并发获取。
&&&

3.1 The Transaction Concept
&&&
3.1 事务的概念
&&&
To solve these problems, the operations performed by a process that is accessing the
database are grouped into sequences called transactions [Eswaran et al. 76]. Thus, users would
interact with a DBMS by executing transactions. In traditional DBMSs, transactions serve three
distinct purposes [Lynch 83]: (1) they are logical units that group together operations that comprise
a complete task; (2) they are atomicity units whose execution preserves the consistency of
the database; and (3) they are recovery units that ensure that either all the steps enclosed within
them are executed, or none are. It is thus by definition that if the database is in a consistent state
before a transaction starts executing, it will be in a consistent state when the transaction terminates.
&&&
为了解决这些问题，操作数据库的操作会被组合成一个称为事务的序列[Eswaran et al. 76]。因此，用户通过执行事务来跟数据库打交道。在传统的关系型数据库中，事务是为了三个不同的目的[Lynch 83]：(1)它们是把完成任务的操作封装起来的逻辑上的单元；(2)它们是能保证一致性的运行单元；和(3)它们是恢复单元，能够保证要么它们包括的所有步骤都能完成，要么全部都不能完成。因此如果一个数据库在开始一个事务前是一直的，那么开执行一个事务后还是一致的。
&&&
In a multi-user system, users execute their transactions concurrently, and the DBMS has to
provide a concurrency control mechanism to guarantee that consistency of data is maintained in
spite of concurrent accesses by different users. From the user’s viewpoint, a concurrency control
mechanism maintains the consistency of data if it can guarantee: (1) that each of the transactions
submitted to the DBMS by a user eventually gets executed; and (2) that the results of the computation
performed by each transaction are the same whether it is executed on a dedicated system
or concurrently with other transactions in a multi-programmed system [Bernstein et al. 87;
Papadimitriou 86].
&&&
在一个多用户系统中，用户并发地运行他们的任务，然后DBMS必须提供一个并发控制机制来保证尽管数据被不同用户并发读写，但是一致性还是能够保证。
&&&

Let us follow up on our previous example to demonstrate the concept of transactions. John
and Mary are assigned the task of fixing two bugs that were suspected to be in modules A and
B. The first bug is caused by an error in procedure p1 in module A, which is called by procedure
p3 in module B (thus fixing the bug might affect both p1 and p3). The second bug is caused by
an error in the interface of procedure p2 in module A, which is called by procedure p4 in B. John
and Mary agree that John will fix the first bug and Mary will fix the second. John starts a
transaction TJohn and proceeds to modify procedure p1 in module A. After completing the
modification, he starts modifying procedure p3 in module B. At the same time, Mary starts a
transaction TMary to modify procedure p2 in module A and procedure p4 in module B.
&&&
浪我们接着刚才的例子来说明事务的概念。John和Mary被分配了修复两个漏洞的任务，这两个漏洞怀疑是来自于模块A和B。第一个漏洞是由于A中p1函数的问题，它会被B模块中的p3函数调用（因此解决这个漏洞可能会同时影响p1和p3）。第二个漏洞是由于A模块的p2函数的接口问题，它会被B模块中的p4函数调用。John和Mary决定John修第一个漏洞然后Mary修第二个。John开始一个事务TJohn然后修改了A模块中的p1函数。然后完成了修改，然后他开始修改B模块中的p3函数。同时，Mary开始了一个事务TMary然后修改A模块中的p2函数然后是B模块的p4函数。
&&&
![fig2](./2fig2.jpg)  
Although TJohn and TMary are executing concurrently, their outcomes are expected to be the
same, had each of them been executed on a dedicated system. The overlap between TMary and
TJohn results in a sequence of actions from both transactions, called a schedule. Figure 2 shows
an example of a schedule made up by interleaving operations from TJohn and TMary. A schedule
that gives each transaction a consistent view of the state of the database is considered a consistent
schedule. Consistent schedules are a result of synchronizing the concurrent operations of
users by allowing only those operations that maintain consistency to be interleaved.
&&&
尽管TJohn和TMary是并行执行的，他们的结果输出都可以认为是一样的，两个都运行在同一个系统上。TMary和TJohn的重写会导致两个事务编程一个执行序列，称为调度。Fig2表明了TJohn和TMary由于调度交替执行的一个例子。一个调度如果会给每个事务一个一致的数据库状态，那么这个调度就认为是遵守一致性的调度。一致性调度室同步多用户并发操作的结果，通过维护遵守一致性的操作互相交织来完成。
&&&

3.2 Serializability
&&&
3.2 串行化
&&&
Let us give a more formal definition of a consistent schedule. Since transactions are consistency
preserving units, if a set of transactions T1, T2, ..., Tn are executed serially (i.e., for every
i= 1 to n-1, transaction Ti is executed to completion before transaction Ti+1 begins), consistency
is preserved. Thus, every serial execution (schedule) is correct by definition. We can then establish
that a serializable execution (one that is equivalent to a serial execution) is also correct.
From the perspective of a DBMS, all computations in a transaction either read or write a data
item from the database. Thus, two schedules S1 and S2 are said to be computationally equivalent
&&&
让我们给出一个一致性调度更正式的定义。因为事务是保证一致性的基本单元，如果一个事务集合T1, T2, ..., Tn 被让位是串行化的（就是说，对于每一个i= 1 到 n-1，事务Ti都是在Ti+1执行前执行结束的），一致性就能被保证。因此每个串行化执行（调度）从定义上就能看出是能保证一致性的。之后我们可以得到那样的可串行化执行（等价于串行化执行）同样也是正确的。从关系型数据库的角度来看，所有事务中的计算要么是读要么是写。因此，当如下条件成立时，两个调度S1和S2可以说是计算上一致的：
&&&
if [Korth and Silberschatz 86]:
1. The set of transactions that participate in S1 and S2 are the same.
2. For each data item Q in S1, if transaction Ti executes read(Q) and the value of Q
read by Ti is written by Tj, then the same will hold in S2 (i.e., read-write
synchronization).
3. For each data item Q in S1, if transaction Ti executes the last write(Q) instruction,
then the same holds also in S2 (i.e., write-write synchronization).
For example, the schedule shown in figure 2 is equivalent to the serial schedule TJohn,
TMary (execute TJohn to completion and then execute TMary) because: (1) the set of transactions
in both schedules are the same; (2) both data items A and B read by TMary are written by TJohn in
both schedules; and (3) TMary executes the last write(A) operation and the last write(B) operation
in both schedules.
&&&
如果 [Korth and Silberschatz 86]：
1. S1和S2中事务的集合一样。
2. 对于每个S1中的数据Q，如果事务Ti运行读(Q)然后Q会被Tj写，这个顺序同时也能在S2中被保证（例如通过读-写同步）。
3. 对于每个S1中的数据项Q，如果事务Ti运行了最后的写，然后同样也能被S2保证（例如写-写同步）。
例如，如果Fig2展示的调度跟串行化执行的TJohn和TMary是相等的（先运行TJohn，完成后再运行TMary）因为（1）两个事务集合是一样的；（2）TMary读的两个数据项A和B都以相同的顺序被TJohn写；并且（3）在两个调度中，TMary都对A和B运行最后的写。
&&&
The consistency problem in conventional database systems reduces to that of testing for
serializable schedules because it is accepted that the consistency constraints are unknown. Each
operation within a transaction is abstracted into either reading a data item or writing it. Achieving
serializability in DBMSs can thus be decomposed into two subproblems: read-write
synchronization and write-write synchronization, denoted rw and ww synchronization,
respectively [Bernstein and Goodman 81]. Accordingly, concurrency control algorithms can be
categorized into those that guarantee rw synchronization, those that are concerned with ww
synchronization, and those that integrate the two. Rw synchronization refers to serializing transactions
in such a way so that every read operation reads the same value of a data item as that it
would have read in a serial execution. Ww synchronization refers to serializing transactions so
that the last write operation of every transaction leaves the database in the same state as it would
have left it in some serial execution. Rw and ww synchronization together result in a consistent
schedule.
&&&
传统数据库系统的及执行问题就变成了看是否可以形成可串行化的调度，因为一致性的规则未知也需要被接受。在事务中的每个操作都被抽象为读写数据。在DBMS中实现可串行化可以因此解耦两个子问题：读-写同步和写-写同步，用rw同步和ww同步来分别表示[Bernstein and Goodman 81]。对应的，并发控制算法可以被分类为保证rw同步和保证ww同步，还有就是两者都保证。rw同步指把事务以就像被串行化执行的方式那样读到相同的数据来执行。ww同步指让每一个事务的最后写操作都让数据库如同串行化执行那样保持同一状态来执行。rw和ww同步一同构建一致性调度。
&&&
When more than one transaction is involved in reading and writing the same object at the
same time, one of the transactions is guaranteed to complete its task while other transactions
must be prevented from executing the conflicting operations until the continuing transaction is
complete and a consistent state is guaranteed. Thus, even though a DBMS may not have any
information about application-specific consistency constraints, it can guarantee consistency by
allowing only serializable executions of concurrent transactions. This concept of serializability
is central to all the concurrency control mechanisms described in the next section. If more
semantic information about transactions and their operations were available, schedules that are
not serializable but that do maintain consistency can be produced. That is exactly what the extended
transaction mechanisms discussed later try to achieve.
&&&
当一个以上的事务同时读写同一个对象，其中一个事务需要被保证完成这个任务，然后另外一个事务必须不能运行冲突的操作，知道正在运行的事务已经结束并且一个一致的状态已经能够被保证。因此，尽管一个DBMS可能不能知道业务特定的一致性要求，它还是能通过允许并发事务的可串行化执行来保证一致性。这个可一致化的概念是下一节并发控制机制的核心。如果可以知道更多的业务相关的一致性要求，不可串行化的调度也可以保证一致性。这正是后面提到的拓展的事务机制。
&&&

4 TRADITIONAL APPROACHES TO CONCURRENCY CONTROL
&&&
4 并发控制的传统方法
&&&
In order to understand why conventional concurrency control mechanisms are too restrictive
for advanced applications, it is necessary to be familiar with the basic ideas of the main
serializability-based concurrency control mechanisms that have been proposed for, and implemented
in, conventional database systems. Most of the mechanisms follow one of five main
approaches to concurrency control: two-phase locking, which is the most popular example of
locking protocols, timestamp ordering, optimistic concurrency control, multiversion concurrency,
and nested transactions, which is relatively orthogonal to the first four mechanisms. In
this section, we briefly describe these five approaches. For a comprehensive discussion and survey
of the topic, the reader is referred to [Bernstein and Goodman 81] and [Kohler 81].
&&&
为了理解为什么传统的并发控制机制对于高级的程序限制太大，有必要理解传统的基于可串行化的并发控制机制和其实现。大多数机制使用五个中的一个方法来做并发控制：两间断锁，一个非常流行的锁协议，时间序，乐观并发控制，多版本并发控制，嵌套事务，这跟前面四个都没什么关联。在这一节我们会大致地描述着五个方法。如果想深入理解这方面的研究，渎职应看[Bernstein and Goodman 81] 和 [Kohler 81]。
&&&

4.1 Locking Mechanisms
4.1.1 Two-Phase Locking
&&&
4.1 锁机制
4.1.1 两阶段锁
&&&
The two-phase locking mechanism (2PL) introduced by Eswaran et al. is now accepted as
the standard solution to the concurrency control problem in conventional database systems. 2PL
guarantees serializability in a centralized database when transactions are executed concurrently.
The mechanism depends on well-formed transactions, which (1) do not relock entities that have
been locked earlier in the transaction, and (2) are divided into a growing phase, in which locks
are only acquired, and a shrinking phase, in which locks are only released [Eswaran et al. 76].
During the shrinking phase, a transaction is prohibited from acquiring locks. If a transaction
tries during its growing phase to acquire a lock that has already been acquired by another transaction,
it is forced to wait. This situation might result in deadlock if transactions are mutually
waiting for each other’s resources.
&&&
两阶段锁（2PL）是由Eswaran et al引入的，现在已经被认为是传统关系型数据库的一个标准的并发处理解决方法。2PL保证了当事务并发执行时，事务能在中央数据库中可串行化。这个机制依赖于精心设计的事务，要求（1）不能锁其他事务已经上的锁，并且（2）上锁被分成两个阶段，只取锁和只解锁两个阶段[Eswaran et al. 76]。在解锁的极端，一个事务是不能获取锁的。如果一个事务尝试在取锁阶段取一个已经被其它事务上了的锁，它会被强制要求等待。这个阶段有可能会因为互相等对方的资源而导致死锁。
&&&
2PL allows only a subset of serializable schedules. In the absence of information about
how and when the data items are accessed, however, 2PL is both necessary and sufficient to
ensure serializability by locking [Yannakakis 82]. If we have prior knowledge about the order of
access of data items, which is often the case in advanced applications, we can construct locking
protocols that are not 2PL but ensure serializability. One such protocol is the tree protocol,
which can be applied if there is a partial ordering on the set of items that are accessed by concurrent
transactions. To illustrate this protocol, assume that a third programmer, Bob, joined the
programming team of Mary and John and is now working with them on the same project. Suppose
that Bob, Mary and John want to modify modules A and B concurrently in the manner
depicted in schedule S1 of figure 3. The tree protocol would allow this schedule to execute
because it is serializable (equivalent to TBob TJohn TMary) even though it does not follow the 2PL
protocol (because TJohn releases the lock on A before it acquires the lock on B). It is possible to
construct S1 because all of the transactions in the example access (write) A before B. This information
about the access patterns of the three transactions was used to construct the non-2PL
schedule shown in the figure. This example demonstrates why 2PL is in fact not appropriate for
advanced applications.
![fig3](./2fig3.jpg)  
&&&
2PL只允许部分的可串行化调度。然而，在没有数据是什么访问的情况下，2PL是一种必须且有效的方法去用锁保证可线性化[Yannakakis 82]。如果我们在高级应用程序中预先知道了访问数据的顺序，我们可以构造非2PL的锁协议来保证可串行化。其中一个这样的协议就是树协议，用于访问数据遵循偏序关系的并发事务中。为了阐明这个协议，假设有三个程序员，Bob参加了Mary和John的团队然后现在他们工作在相同的项目上。假设三人现在想以Fig3的方式并发修改模块A和B。树协议就可以允许这样的调度来执行因为它是可串行化的（跟TBob TJohn TMary一直）尽管它不符合两阶段锁协议（因为TJohn在锁B前解锁了A）。构造这样的S1是可以的，因为所有的事务在B写之前先写了A。这种三个事务访问的模式被用于构造非2PL调度，就如图那样。这个例子阐述了为什么2PL事实上并不适用于高级应用。
&&&

4.2 Timestamp Ordering
&&&
4.2 时间戳顺序
&&&
One of the problems of locking mechanisms is deadlock, which occurs when two or more
transactions are mutually waiting for each other’s resources. This problem can be solved by
assigning each transaction a unique number, called a timestamp, chosen from a monotonically
increasing sequence, which is often a function of the time of the day [Kohler 81]. Using timestamps,
a concurrency control mechanism can totally order requests from transactions according
to the transactions’ timestamps [Rosenkrantz et al. 78]. The mechanism forces a transaction requesting
to access a resource that is being held by another transaction to either (1) wait until the
other transaction that has hold of the requested resource at that time terminates, (2) abort itself
and restart if it cannot be granted the request, or (3) preempt the other transaction and get hold of
the resource. A scheduling protocol decides which one of these three actions to take after comparing
the timestamp of the requesting transaction with the timestamps of conflicting transactions.
The protocol must guarantee that a deadlock situation will not arise.
&&&
锁机制的其中一个问题是死锁，出现在两个或多个事务互相等对方的资源时。这个问题可以被一个方法解决，每个事务被绑定一个数字，叫时间戳，从一个单调底层的序列中选择，一般来说是来自一个取使劲的函数。[Kohler 81]使用时间戳，一个并发控制机制可以完全用事务的时间戳来协调。[Rosenkrantz et al. 78]这个机制要求了请求访问被占有资源的事务（1）等到其他事务释放资源，（2）自己停止并重启自己，（3）比别人先拿到资源。一个调度协议会决定三个行为中会用那个行为，通过比较冲突事务的时间戳。这个协议必须保证不会发生死锁。
&&&
Two of the possible alternative scheduling protocols used by timestamp-based mechanisms
are: (1) the WAIT-DIE protocol, which forces a transaction to wait if it conflicts with a running
transaction whose timestamp is more recent, or to die (abort and restart) if the running
transaction’s timestamp is older; and (2) the WOUND-WAIT protocol, which allows a transaction
to wound (preempt by suspending) a running one with a more recent timestamp, or forces
the requesting transaction to wait otherwise. Locks are used implicitly in this technique since
some transactions are forced to wait as if they were locked out.
&&&
两个可能的其它使用了基于时间戳机制的调度协议是（1）WAIT-DIE协议，强制一个事务在冲突时等待，或者自己结束或重启自己如果自己的时间戳比较靠后；还有（2）WOUND-WAIT协议，允许事务杀死一个或多个比自己造的事务，或者强制等待的事务等待。这种机制隐式地使用了锁因为一些事务需要被强制等待然后被唤醒。
&&&

4.3 Multiversion Timestamp Ordering
&&&
4.3 多版本时间戳排序
&&&
The timestamp ordering mechanism above assumes that only one version of a data item
exists. Consequently, only one transaction can access a data item at a time. This mechanism can
be improved in the case of read-write synchronization by allowing multiple transient versions of
a data item to be read and written by different transactions, as long as each transaction sees a
consistent set of versions for all the data items that it accesses. This is the basic idea of the
multiversion scheme introduced by Reed [Reed 78]. In Reed’s mechanism, each transaction is
assigned a unique timestamp when it starts; all operations of the transaction are assigned the
same timestamp. For each data item x there is a set of read timestamps and a set of <write
timestamp, value> pairs, called transient versions.
&&&
上述提到的时间错排序机制只会给一个数据项标上一个版本的时间错。结果是，只有一个事务可以同时访问一个数据，这种机制在读写同步的时候可以改良成让多个过度版本的数据项被读然后被不同的的事务写，只要每个事务见到了所有数据项的一个一致的版本集合。这个Reed[Reed 78]引入一个多版本模式的基本事项。在Reed的机制中，每个事务在一开始会被赋予一个时间戳，每个事务中的操作都会被赋予相同的时间戳。对于每个数据项x就有一个读时间戳集合还有一个<写 时间戳 数据>二元组集合，称为过度版本。
&&&
The existence of multiple versions eliminates the need for write-write synchronization since
each write operation produces a new version and thus can not conflict with another write operation.
The only possible conflicts are those corresponding to read-from relationships [Bernstein et
al. 87], as demonstrated by the following example.
&&&
多版本的出现使ww同步变得不再必要，因为每个写都会产生一个新的版本，因此不能跟其它写操作冲突。唯一可能的冲突时那些具有“从关系读”的的情况[Bernstein et
al. 87]，下面将举例说明。
&&&
Let R(x) be a read operation with timestamp TS(R). R(x) is processed by reading the value
of the version of x whose timestamp is the largest timestamp smaller than TS(R). TS(r) is then
added to the set of read timestamps of item x. Similarly, let W(x) be a write operation that
assigns value v to item x, and let its timestamp be TS(W). Let interval(W) be the interval from
TS(W) to the smallest timestamp of a version of x greater than TS(W) (i.e., a version of x that
was written by another transaction whose timestamp is more recent than TS(W)). A situation
like this occurs because of delays in executing operations within a transaction (the write operation
might have been the last operation after many other operations in the same transaction).
Because of those delays, an operation Oi belonging to transaction Ti might be executed after Ti
had started by a period of time. In the meanwhile, other operations from a more recent transaction
might have been performed. If any read timestamps lies in the interval (i.e., a transaction
has already read a value of x written by a more recent write operation than W), then W is
rejected (and the transaction is aborted). Otherwise, W is allowed to create a new version of x.
&&&
设R(x)是一个时间戳为TS(R)的读操作。R(x)会读一个时间戳跟它最近但比它小的x版本的值。TS(r)然后就会被加到数据项x的读时间戳集合中。类似的，设W(x)施一个给x赋值为v的写操作，它的时间戳是TS(W)。假设interval(W)是从TS(W)到比TS(W)大的最小的时间戳的时间段（就是说，一个x的写版本，这个写版本离TS(W)最近但比它早）。一种出现这种情况的原因是因为一个事务的操作被延迟了（写操作可能是十五中的最后操作）。因为了这些延迟，一个操作属于Ti的Oi可能会在Ti开始一段时间后运行。同时，其他来自相同事务的操作可能会被执行。如果任何读时间戳在这个时间段里面（就是说，一个事务可能已经读了一个比W更早的的值），然后W就会被拒绝（然后事务被终止）。否则，W就可以创建一个x的新版本。
&&&

4.4 Optimistic Non-Locking Mechanisms
In many applications, locking has been found to constrain concurrency and to add an unnecessary
overhead. The locking approach has the following disadvantages [Kung and Robinson
81]:
&&&
4.4 乐观无锁机制
在很多应用程序中，所已经被发现了限制了并发并且加入了不必要的开销。锁方法有下面的缺陷[Kung and Robinson
81]:
&&&
1. Lock maintenance represents an unnecessary overhead for read-only transactions,
which do not affect the integrity of the database.
2. Most of the general-purpose deadlock-free locking mechanisms work well only in
some cases but perform rather poorly in other cases. There are no locking
mechanisms that provide high concurrency in all cases.
3. When large parts of the database resides on secondary storage, locking of objects
that are accessed frequently (referred to as congested nodes), while waiting for
secondary memory access, causes a significant decrease in concurrency.
&&&
1. 维护锁对于只读事务来说引入了不必要的开销，并且不影响数据库的完整性。
2. 大部分通用的无死锁锁机制只有在一些场景才能工作，在其它则不能。在所有情况下，锁都不能提供高并发支持。
3. 当数据库的大部分都在次级存储上，锁一个已经被访问的对象（被称为阻塞结点），当等待二级存储的时候，就会导致严重的并发性能降低。
&&&
4. Not permitting locks to be unlocked until the end of the transaction, which although
not required is always done in practice to avoid cascaded aborts, decreases
concurrency.
5. Most of the time it is not necessary to use locking to guarantee consistency since
most transactions do not overlap; locking may be necessary only in the worst case.
&&&
4. 在事务结束前不允许解锁，虽然并不一定要这么做单在时间做会为了防止连续的终止而很常用，这会降低并发能力。
5. 大部分时间为了保证一致性都用来锁了很浪费，因为大部分的事务不会重叠；要锁可能只是最坏的情况，
&&&
To avoid these problems, Kung and Robinson presented the concept of "optimistic" concurrency
control by introducing two families of concurrency control mechanisms (serial validation
and parallel validation) that do not use locking. They require each transaction to consist of two
or three phases: a read phase, a validation phase and possibly a write phase. During the read
phase, all writes take place on local copies (also referred to as transient versions) of the records
to be written. Then, if it can be established during the validation phase that the changes the
transaction made will not cause loss of integrity, i.e., that they are serializable with respect to all
committed transactions, the local copies are made global and thus accessible to other transactions
in the write phase.
&&&
为了规避这些问题，Kung和Robinson展示了一种乐观并发控制的概念，它引用了两组不用锁的并发控制机制（串行化校验和并行化校验）。他们需要每个事务都由两个阶段组成：读阶段，验证阶段还有可选的写极端。在过度阶段中，所有被写记录的写都是在本地完成的（也成为过度版本）。然后如果可以在验证阶段被事实那么就不会产生完整性问题，就是说，他们对于所有的提交事务都是串行化的，本地的副本会写进全局然后因此可以被其它事务看到。
&&&
Validation is done by assigning each transaction a timestamp at the end of the read phase
and synchronizing using timestamp ordering. The correctness criteria used for validation are
based on the notion of serial equivalence. Any schedule produced by this technique ensures that
if transaction Ti has a timestamp less than the timestamp of transaction Tj then the schedule is
equivalent to the serial schedule Ti followed by Tj. This can be ensured if any one of the following
three conditions holds:
&&&
验证是通过在每一个事务的读阶段最后给一个时间错然后利用时间戳同步来是吸纳。验证的正确性是基于跟串行化是相等的。任何这种技术导致的调度会保证如果Ti事务已经有了一个比Tj事务小的时间戳，那么调度就会等价于串行地执行Ti然后Tj。如果任何下面三个中的一个成立，这就能被保证：
&&&
1. Ti completes its write phase before Tj starts its read phase.
2. The set of data items written by Ti does not intersect with the set of data items read
by Tj, and Ti completes its write phase before Tj starts its write phase.
3. The set of data items written by Ti does not intersect with the set of data items read
or written by Tj, and Ti completes its read phase before Tj completes its read phase.
&&&
1. Ti在Tj开始读阶段前完成了它的写阶段。
2. 被Ti写的数据集不会跟Tj读的数据集有交集，然后Ti在Tj开始写阶段前完成了它的写阶段。
3. 被Ti写的数据集不会跟Tj读或写的数据集有交易，然后Ti在Tj完成读阶段前完成了它的读阶段。
&&&

Although optimistic concurrency control allows more concurrency under certain circumstances,
it decreases concurrency when the read and write sets of the concurrent transactions
overlap. For example, Kung and Robinson’s protocol would cause one of transactions in the
simple 2PL schedule in figure 2 to be rolled back and restarted. From the viewpoint of advanced
applications, the use of rollback as the main mechanism of achieving serializability is a serious
disadvantage. Since operations in advanced transactions are generally long-lived (e.g., compiling
a module), rolling them back and restarting them wastes all the work that these operations
did (the object code produced by compilation). The inappropriateness of rolling back a long
transaction in advanced applications is discussed further in section 5.
&&&
尽管乐观并行控制在一些情况下可以使用，它降低了并发中读写集合的重叠。例如Kung 和 Robinson 的协议会导致其中一个在简单Fig2中2PL的调度的事务被回滚和重启。在高级应用程序来看，以回滚作为主要的获取串行化的机制是一个很严重的弊端，因为在高级的十五中草种一般是常会时间的（例如编译一个模块），回滚然后重新开始他们会浪费很多工作（编译生成的目标代码）。高级应用程序中一个长事务的不必要的回滚会在第5节讨论。
&&&

4.5 Multiple Granularity Locking
&&&
4.5 多粒度锁
&&&
All the concurrency control protocols described so far operate on individual data items to
achieve synchronization of transactions. It is sometimes desirable, however, to able to access a
set of data items as a single unit, e.g., to effectively lock each item in the set in one operation
rather than having to lock each item individually. Gray et al. presented a multiple granularity
concurrency control protocol, which aims to minimize the number of locks used while accessing
sets of objects in a database [Gray et al. 75]. In their model, Gray et al. organize data items in a
tree where items of small granularity are nested within larger ones. Each non-leaf item
represents the data associated with its descendants. This is different from the tree protocol
presented above in that the nodes of the tree (or graph) do not represent the order of access of
individual data items but rather the organization of data objects. The root of the tree represents
the whole database. Transactions can lock nodes explicitly, which in turn locks descendants
implicitly. Two modes of locks were defined: exclusive and shared. An exclusive (X) lock
excludes any other transaction from accessing (reading or writing) the node; a shared (S) lock
permits other transaction to read the same node concurrently, but prevents any updating of the
node.
&&&
所有目前描述到的并发控制协议都是对单个数据项操作来实现事务的同步的。然而有事我们需要能够以一个单元来访问一组数据，例如要高效地对一个集合中每个数据项高速地加锁，而不是给每个数据项一个一个加锁。Gray et al。给出了一种多粒度的并发控制协议，目的是在访问数据库中对象的集合时能减少锁的数量[Gray et al. 75]。在他们的模型中，Gray et al.以树来组织数据项，其中小粒度的嵌在大粒度的数据中。每个非野子结点代表与子孙相关的数据。这跟上面提到的树协议不同，它们的树（或图）不表示访问数据的顺序，而是用来组织数据对象。树的根节点表示整个数据库。事务可以显式地锁结点，同时会把所有子孙都锁上。这定义了两种锁的模式：互斥和共享。一个互斥（X）锁防止任何其他事务访问（读或写）结点；一个共享（S）锁允许其他事务并发读结点，但不给更新结点。
&&&
To determine whether to grant a transaction a lock on a node (given these two modes), the
transaction manager would have to follow the path from the root to the node to find out if any
other transaction has explicitly locked any of the ancestors of the node. This is clearly inefficient.
To solve this problem, a third kind of lock mode called intention lock mode was
introduced [Gray 78]. All the ancestors of a node must be locked in intention mode before an
explicit lock can be put on the node. In particular, nodes can be locked in five different modes.
A non-leaf node is locked in intention-shared (IS) mode to specify that descendant nodes will be
explicitly locked in shared (S) mode. Similarly, an intention-exclusive (IX) lock implies that
explicit locking is being done at a lower level in an exclusive (X) mode. A shared and intentionexclusive
(SIX) lock on a non-leaf node implies that the whole subtree rooted at the node is
being locked in shared mode, and that explicit locking will be done at a lower level with
exclusive-mode locks. A compatibility matrix for the five kinds of locks is defined as shown in
figure 4. The matrix is used to determine when to grant lock requests and when to deny them.
Finally, a multiple granularity protocol based on the compatibility matrix was defined as
follows:
&&&
为了决定是否给一个事务某个结点的锁（给定的这两个模式），事务管理器必须要从根节点一直遍历看看其它事务有没有已经锁了路径上的结点。这很明显会低效。为了解决这个问题，第三种叫做意图锁模式被发明出来[Gray 78]。在锁结点之前，所有结点的祖先必须被意图锁锁住。特别的，结点可以被五种模式锁住。一个非野子结点可以以意图-共享(IS)模式来指定子孙将以共享模式(S)锁住。类似的，一个意图-互斥锁是说会在底层锁上互斥模式锁。一个对于非叶子结点的共享和意图互斥(SIX)锁会在底层锁上互斥模式锁。一个对于这五种锁的呼唤矩阵在Fig4中。这个矩阵是用于决定什么时候请求什么锁还有什么时候拒绝请求。最后一种基于呼唤矩阵的多粒度协议如下定义：
&&&
![fig3](./2fig4.jpg)
1. Before requesting an S or IS lock on a node, all ancestor nodes of the requested
node must be held in IX or IS mode by the requester.
2. Before requesting an X, SIX or IX lock on a node, all ancestor nodes of the requested
node must be held in SIX or IX mode by the requester.
3. Locks should be released either at the end of the transaction (in any order) or in
leaf to root order. In particular, if locks are not held to the end of a transaction, it
should not hold a lock on a node after releasing its ancestors.
&&&
1. 在请求一个结点的S或者IS锁之前，请求方必须已经得到这个结点所有祖先的IX或者IS模式锁。
2. 在请求一个结点的X，SIX或者IX锁之前，请求方必须得带所有该结点的祖先的SIX或者IX模式锁。
3. 锁必须在事务的结尾（以任何顺序）或者以叶子到根的顺序释放。特别的，如果一个锁在事务的末尾没有内锁住，这个事务也不应该在释放其祖先后或者这个锁。
&&&
The multiple granularity protocol increases concurrency and decreases overhead especially
when there is a combination of short transactions with a few accesses and transactions that last
for a long time accessing a large number of objects such as audit transactions that access every
item in the database. The Orion object-oriented database system provides a concurrency control
mechanism based on the multi-granularity mechanism described above [Kim et al. 88; Garza and
Kim 88].
&&&
多例如度协议提升了并发能力并且降低了耗费，特别是在当有一组很少访问数据并且会花很多时间来访问大量对象的事务组合，例如访问数据库中每个数据项的审计事务。Orion面向对象数据库系统提供了一种基于上述多粒度机制的并发控制机制[Kim et al. 88; Garza 和 Kim 88]。
&&&

4.6 Nested Transactions
A transaction, as presented above, is a set of primitive atomic actions abstracted as read and
write operations. Each transaction is independent of other transactions. In practice, there is a
need to compose several transactions into one unit (i.e., one transaction) for two reasons: (1) to
provide modularity; and (2) to provide finer grained recovery. The recovery issue maybe the
more important one, but it is not addressed in detail here since the focus of this paper is on
concurrency control. The modularity problem is concerned with preserving serializability when
composing two or more transactions. One way to compose transactions is gluing together the
primitive actions of all the transactions by concatenating the transactions in order into one big
transaction. This preserves consistency but decreases concurrency because the resulting transaction
is really a serial ordering of the subtransactions. Interleaving the actions of the transactions
to provide concurrent behavior, on the other hand, can result in violation of serializability
and thus consistency. What is needed is to execute the composition of transactions as a transaction
in its own right, and to provide concurrency control within the transaction.
The idea of nested spheres of control, which is the origin of the nested transactions concept,
was first introduced by Davies [Davies 73] and expanded by Bjork [Bjork 73]. Reed presented a
comprehensive solution to the problem of composing transactions by formulating the concept of
nested transactions [Reed 78]. A nested transaction is a composition of a set of subtransactions;
each subtransaction can itself be a nested transaction. To other transactions, the top-level nested
transaction is visible and appears as a normal atomic transaction. Internally, however, subtransactions
are run concurrently and their actions are synchronized by an internal concurrency control
mechanism. The more important point is that subtransactions fail and can be restarted or
replaced by another subtransaction independently without causing the whole nested transaction
to fail or restart. In the case of gluing the actions of subtransactions together, on the other hand,
the failure of any action would cause the whole new composite transaction to fail. In Reed’s
design, timestamp ordering is used to synchronize the concurrent actions of subtransactions
within a nested transaction. Moss designed a nested transaction system that uses locking for
synchronization [Moss 85]. Moss’s design also manages nested transactions in a distributed system.
![fig5](./2fig5.jpg)
As far as concurrency is concerned, the nested transaction model presented above does not
change the meaning of transactions (in terms of being atomic) and it does not alter the concept of
serializability. The only advantage is performance improvement because of the possibility of
increasing concurrency at the subtransaction level, especially in a multiprocessor system. To
illustrate this, consider transactions TJohn and TMary of figure 2. We can construct each as a
nested transaction as shown in figure 5. Using Moss’s algorithm, the concurrent execution of
John’s transaction and Mary’s transaction will produce the same schedule presented in figure 2.
Within each transaction, however, the two subtransactions can be executed concurrently, improving
the overall performance.
It should be noted that combinations of optimistic concurrency control, multiversion objects,
and nested transactions is the basis for many of the concurrency control mechanisms
proposed for advanced database applications. To understand the reasons behind this, we have to
address how the nature of data and computations in advanced database applications imposes new
requirements on concurrency control. We explore these new requirements in the next section,
and then present several approaches that take these requirements into consideration in rest of the
paper.